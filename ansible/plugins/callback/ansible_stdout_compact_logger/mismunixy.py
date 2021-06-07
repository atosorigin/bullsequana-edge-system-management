#
# Atos BullSequana Edge Ansible Modules
# Version 2.0
# Copyright (C) 2019 Atos or its subsidiaries. All Rights Reserved.

# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
#

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    callback: mismunixy
    type: stdout
    author: Francine Sauvage <@fsauvage>
    short_description: condensed Ansible output
    version_added: 2.9 (devel)
    description:
      - Consolidated Ansible output in the style of LINUX/UNIX startup logs.
    extends_documentation_fragment:
      - default_callback
    requirements:
      - set as stdout in configuration
'''

import yaml
import json
import_tzlocal = False
try: 
    import tzlocal
    import_tzlocal = True
except:
    pass
from datetime import datetime
from os.path import basename
from datetime import datetime
from ansible import constants as C
from ansible import context
from ansible.module_utils._text import to_text
from ansible.parsing.yaml.dumper import AnsibleDumper
from ansible.utils.color import colorize, hostcolor
from ansible.utils.unsafe_proxy import AnsibleUnsafeText
from ansible.plugins.callback import CallbackBase, strip_internal_keys, module_response_deepcopy
from ansible.plugins.callback.default import CallbackModule as Default

class CallbackModule(Default):

    '''
    Design goals:
    - Print consolidated output that looks like a *NIX startup log
    - Defaults should avoid displaying unnecessary information wherever possible
    TODOs:
    - Only display task names if the task runs on at least one host
    - Add option to display all hostnames on a single line in the appropriate result color (failures may have a separate line)
    - Consolidate stats display
    - Display whether run is in --check mode
    - Don't show play name if no hosts found
    '''

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'mismunixy'

    def _run_is_verbose(self, result):
        return ((self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and '_ansible_verbose_override' not in result._result)

    def get_name(self, task):
        self.task_display_name = None
        display_name = task.get_name().strip().split(" : ")
        task_display_name = display_name[-1]
        if not task_display_name:
            return None
        if task_display_name.startswith("include"):
            return None
        self.task_display_name = task_display_name

    def _preprocess_result(self, result):
        self.delegated_vars = result._result.get('_ansible_delegated_vars', None)
        self._handle_exception(result._result, use_stderr=self.display_failed_stderr)
        self._handle_warnings(result._result)

    def _display_result_output(self, result, msg, display_color, err=None, render_one=False):
        #self._display.display("%s %s" % (self._dump_results(result._result, indent=2), err))
        #return
        ts = self.tark_started.strftime("%H:%M:%S")
        task_host = result._host.get_name()
        task_result = "[{task_time}] {host} | {duration:>8.3f}ms".format(task_time=ts, host=task_host, duration=self._get_duration())
        # Sensors
        sensors = result._result.get("sensors", None)         
        if sensors:          
            self.deep_serialize_sensors(task_result, sensors, False)
            return
        # Logs
        logs = result._result.get("logs", None)         
        if logs:          
            self.deep_serialize_logs(task_result, logs, True)
            return
        
        # Upload        
        if result._result.get('url', None) and result._result.get('msg', None) and "/upload/image" in result._result.get('url', None) :
            # specific case : not a failure => Version already exists OR tar extraction error
            json_body = result._result.get('json', None)
            if not json_body: # return default msg
                task_result += " | " + to_text(result._result.get('msg', None))
                self._display.display(task_result, display_color, stderr=err)
                return

            json_data = json_body.get('data', None)
            if not json_data: # return default msg
                task_result += " | " + to_text(result._result.get('msg', None))
                self._display.display(task_result, display_color, stderr=err)
                return

            if type(json_data) is str:
                task_result += " | Upload: " + json_data
                self._display.display(task_result, display_color, stderr=err)
                return


            if type(json_data) is AnsibleUnsafeText :
                task_result_final = "{task_result} | image id: {json_data}".format(task_result=task_result, json_data=json_data)
                self._display.display(task_result_final, display_color, stderr=err)
                return
 
            data_description = json_data.get('description', None)

            if data_description: 
                task_result += " | " + to_text(data_description)
                self._display.display(task_result, display_color, stderr=err)
                return
            

            # else = return default msg
            self._display.display("Pas de description Upload", display_color, stderr=err)
            msg = result._result.get('msg', None)
            if msg:
                task_result += " | " + to_text(msg)
                self._display.display(task_result, display_color, stderr=err)
                return
            self._display.display("OK Upload", display_color, stderr=err)
            return            

        # debug msg
        if result._result.get('msg') and result._result.get('msg') != "All items completed":
            task_result += " | " + to_text(result._result.get('msg'))
            self._display.display(task_result, display_color, stderr=err)
            return
            
        if self._run_is_verbose(result):
            task_result = "%s | %s: %s" % (task_result, msg, self._dump_results(result._result, indent=4, render_one=render_one))
            self._display.display(task_result, display_color, stderr=err)
            return
        
        task_result = "[{task_time}] {host} | {duration::>8.3f}ms".format(task_time=ts, host=task_host, duration=self._get_duration())
        if self.delegated_vars:
            task_delegate_host = self.delegated_vars['ansible_host']
            task_result = "%s -> %s %s" % (task_host, task_delegate_host, msg)
            self._display.display(task_result, display_color, stderr=err)
            return

        if result._result.get('stdout'):
            task_result += " | stdout: " + result._result.get('stdout')
            self._display.display(task_result, display_color, stderr=err)
            return

        if result._result.get('stderr'):
            task_result += " | stderr: " + result._result.get('stderr')
            self._display.display(task_result, display_color, stderr=err)
            return

    def v2_playbook_on_task_start(self, task, is_conditional):
        self.get_name(task)
        if self.task_display_name :
            self.tark_started = datetime.now()
            self._display.display("%s..." % self.task_display_name)

    def v2_playbook_on_handler_task_start(self, task):
        self.get_name(task)
        if self.task_display_name :
            self._display.display("%s (via handler)... " % self.task_display_name)

    def v2_playbook_on_play_start(self, play):
        name = play.get_name().strip()
        if name and play.hosts:
            msg = u"\n- %s on hosts: %s -" % (name, ",".join(play.hosts))
        else:
            msg = u"---"

        self._display.display(msg)

    def v2_runner_on_skipped(self, result, ignore_errors=False):  
         
        if self.display_skipped_hosts:
            self._preprocess_result(result)
            display_color = C.COLOR_SKIP
            self._display_result_output(result, "skipped", display_color)            
        else:
            return

    def v2_runner_on_failed(self, result, ignore_errors=False):        
        self._preprocess_result(result)
        display_color = C.COLOR_ERROR
        if ignore_errors:
            self._display_result_output(result, "failed", display_color)
        else:
            self._display_result_output(result, "failed", display_color, self.display_failed_stderr)

    def v2_runner_on_ok(self, result, msg="ok", display_color=C.COLOR_OK):
        self.tark_started = datetime.now()
        self._preprocess_result(result)
        result_was_changed = ('changed' in result._result and result._result['changed'])
        render_one=False

        self.get_name(result._task)
        #self._display.display("%s (task name)... " % self.task_display_name)
        if self.task_display_name and self.task_display_name.startswith("render one"):
            render_one = True
        if result_was_changed:
            msg = msg + " done"
            display_color = C.COLOR_CHANGED
            self._display_result_output(result, msg, display_color, render_one=render_one)
        else:# if self.display_ok_hosts:
            self._display_result_output(result, msg, display_color, render_one=render_one)

    def v2_runner_item_on_skipped(self, result):
        self.v2_runner_on_skipped(result)

    def v2_runner_item_on_failed(self, result):
        self.v2_runner_on_failed(result)

    def v2_runner_item_on_ok(self, result):
        self.v2_runner_on_ok(result)

    def v2_runner_on_unreachable(self, result):
        self._preprocess_result(result)

        msg = "unreachable"
        display_color = C.COLOR_UNREACHABLE
        self._display_result_output(result, msg, display_color, self.display_failed_stderr)

    def v2_on_file_diff(self, result):
        if result._task.loop and 'results' in result._result:
            for res in result._result['results']:
                if 'diff' in res and res['diff'] and res.get('changed', False):
                    diff = self._get_diff(res['diff'])
                    if diff:
                        self._display.display(diff)
        elif 'diff' in result._result and result._result['diff'] and result._result.get('changed', False):
            diff = self._get_diff(result._result['diff'])
            if diff:
                self._display.display(diff)

    def v2_playbook_on_stats(self, stats):
        self._display.display("\n- Play recap -", screen_only=True)

        hosts = sorted(stats.processed.keys())
        for h in hosts:
            # TODO how else can we display these?
            t = stats.summarize(h)

            self._display.display(u"  %s : %s %s %s %s %s %s" % (
                hostcolor(h, t),
                colorize(u'ok', t['ok'], C.COLOR_OK),
                colorize(u'changed', t['changed'], C.COLOR_CHANGED),
                colorize(u'unreachable', t['unreachable'], C.COLOR_UNREACHABLE),
                colorize(u'failed', t['failures'], C.COLOR_ERROR),
                colorize(u'rescued', t['rescued'], C.COLOR_OK),
                colorize(u'ignored', t['ignored'], C.COLOR_WARN)),
                screen_only=True
            )

            self._display.display(u"  %s : %s %s %s %s %s %s" % (
                hostcolor(h, t, False),
                colorize(u'ok', t['ok'], None),
                colorize(u'changed', t['changed'], None),
                colorize(u'unreachable', t['unreachable'], None),
                colorize(u'failed', t['failures'], None),
                colorize(u'rescued', t['rescued'], None),
                colorize(u'ignored', t['ignored'], None)),
                log_only=True
            )
        if stats.custom and self.show_custom_stats:
            self._display.banner("CUSTOM STATS: ")
            # per host
            # TODO: come up with 'pretty format'
            for k in sorted(stats.custom.keys()):
                if k == '_run':
                    continue
                self._display.display('\t%s: %s' % (k, self._dump_results(stats.custom[k], indent=1).replace('\n', '')))

            # print per run custom stats
            if '_run' in stats.custom:
                self._display.display("", screen_only=True)
                self._display.display('\tRUN: %s' % self._dump_results(stats.custom['_run'], indent=1).replace('\n', ''))
            self._display.display("", screen_only=True)

    def v2_playbook_on_no_hosts_matched(self):
        self._display.display("  No hosts found!", color=C.COLOR_DEBUG)

    def v2_playbook_on_no_hosts_remaining(self):
        self._display.display("  Ran out of hosts!", color=C.COLOR_ERROR)

    def v2_playbook_on_start(self, playbook):
        # TODO display whether this run is happening in check mode
        self._display.display("Executing playbook %s" % basename(playbook._file_name))

        # show CLI arguments
        if self._display.verbosity > 3:
            if context.CLIARGS.get('args'):
                self._display.display('Positional arguments: %s' % ' '.join(context.CLIARGS['args']),
                                      color=C.COLOR_VERBOSE, screen_only=True)

            for argument in (a for a in context.CLIARGS if a != 'args'):
                val = context.CLIARGS[argument]
                if val:
                    self._display.vvvv('%s: %s' % (argument, val))

    def v2_runner_retry(self, result):
        msg = "  Retrying... (%d of %d)" % (result._result['attempts'], result._result['retries'])
        if self._run_is_verbose(result):
            msg += "Result was: %s" % self._dump_results(result._result)
        self._display.display(msg, color=C.COLOR_DEBUG)

    def _dump_results(self, result, indent=None, sort_keys=True, keep_invocation=False, render_one=False):
        if result.get('_ansible_no_log', False):
            return json.dumps(dict(censored="The output has been hidden due to the fact that 'no_log: true' was specified for this result"))

        # All result keys stating with _ansible_ are internal, so remove them from the result before we output anything.
        abridged_result = strip_internal_keys(module_response_deepcopy(result))

        # remove invocation unless specifically wanting it
        if not keep_invocation and self._display.verbosity < 3 and 'invocation' in result:
            del abridged_result['invocation']

        # remove diff information from screen output
        if self._display.verbosity < 3 and 'diff' in result:
            del abridged_result['diff']

        # remove exception from screen output
        if 'exception' in abridged_result:
            del abridged_result['exception']

        dumped = ''

        # put changed and skipped into a header line
        if 'changed' in abridged_result:
            dumped += 'changed=' + str(abridged_result['changed']).lower() + ' '
            del abridged_result['changed']

        if 'skipped' in abridged_result:
            dumped += 'skipped=' + str(abridged_result['skipped']).lower() + ' '
            del abridged_result['skipped']

        # if we already have stdout, we don't need stdout_lines
        if 'stdout' in abridged_result and 'stdout_lines' in abridged_result:
            abridged_result['stdout_lines'] = '<omitted>'

        # if we already have stderr, we don't need stderr_lines
        if 'stderr' in abridged_result and 'stderr_lines' in abridged_result:
            abridged_result['stderr_lines'] = '<omitted>'

        if abridged_result:
            if not render_one:
                dumped += '\n'
            frus = result.get("frus", None)         
            if frus:
                dumped += to_text(yaml.dump(abridged_result, allow_unicode=True, width=1000, Dumper=AnsibleDumper, default_flow_style=False)).replace("xyz.openbmc_project.", "").replace("/xyz/openbmc_project/inventory/system/chassis/motherboard/","")
            else:
                dumped += to_text(yaml.dump(abridged_result, allow_unicode=True, width=1000, Dumper=AnsibleDumper, default_flow_style=False)).replace("xyz.openbmc_project.", "")

        # indent by a couple of spaces
        if not render_one:
            dumped = '\n  '.join(dumped.split('\n')).rstrip()
        else:
            dumped = dumped.replace('\n', '')
        return dumped
        
#
# Render
#
    # get_sensors.yml
    '''
    - name: Render sensors
      debug: sensors
    '''
    def deep_serialize_sensors(self, name, sensors, check=False):
        self._display.display("{header_name}".format(header_name=name+" | sensors:"))
        output = "{header_key:<40}:{header_value:>14}{header_crit_low:>14}{header_crit_high:>14}{unit:>9}".format(header_key="sensor", header_value="current",header_crit_low="crit low",header_crit_high="crit high",unit="unit")
        self._display.display(output, color='bright blue')
        sorted_sensors = sorted(sensors.items(), key=getKey)
        for (key, sensor) in sorted_sensors:
            value = sensor.get("Value", None)
            crit_low = sensor.get("CriticalLow", "0.0")
            crit_high = sensor.get("CriticalHigh", "0.0")

            unit = sensor.get("Unit", None).replace("xyz.openbmc_project.Sensor.Value.Unit.", "")
            scale = sensor.get("Scale", None)
            value_float = None
            crit_low_float = None
            crit_high_float = None
            try:
                value_float = float(value)
                crit_low_float = float(crit_low)
                crit_high_float = float(crit_high)
                if scale == -3 :
                    value_float = value_float / 1000
                    crit_low_float = crit_low_float / 1000
                    crit_high_float = crit_high_float / 1000
                    unit = "{unit}".format(unit=unit)
                if scale == -6 :
                    value_float = value_float / 1000000
                    crit_low_float = crit_low_float / 1000000
                    crit_high_float = crit_high_float / 1000000
                    unit = "{unit}".format(unit=unit)
                    
                if scale == 3 :
                    unit = "k{unit}".format(unit=unit)
                if scale == 6 :
                    unit = "M{unit}".format(unit=unit)
                output = "{key:<40}:{value:14.2f}{crit_low:14.2f}{crit_high:14.2f}{unit:>9}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value_float,crit_low=crit_low_float,crit_high=crit_high_float,unit=unit)
            except:
                output = "{key:<40}:{value:>14}{crit_low:>14}{crit_high:14}{unit:>9}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value,crit_low=crit_low,crit_high=crit_high,unit=unit)
            
            if value_float < crit_low_float :
                self._display.display(output, color='red')
                continue

            if value_float > crit_high_float :
                self._display.display(output, color='red')
                continue
            self._display.display(output, color='green')

    # get_logs.yml
    '''
        - name: Render logs
          debug: logs

    logs:
        /xyz/openbmc_project/logging/config/remote:
            Address: 129.182.247.57
            Port: 514
        /xyz/openbmc_project/logging/entry/1:
            AdditionalData: []
            Id: 1
            Message: BMC booted from main flash
            Purpose: Software.Version.VersionPurpose.BMC
            Resolved: false
            Severity: Logging.Entry.Level.Informational
            Timestamp: 1573142176232
            Version: 18.00.0214
            associations: []
        /xyz/openbmc_project/logging/internal/manager: {}
        /xyz/openbmc_project/logging/rest_api_logs:
            Enabled: false

    '''        
    def deep_serialize_logs(self, name, logs, check=False):
        self._display.display("{header_name}".format(header_name=name+" | logs"))
        output = "{id_log:<5}{purpose:<10}{resolved:<10}{severity:<15}{date_log:<33}{version:<15}{message:<}".format(id_log="id", message="message",purpose="purpose",resolved="resolved",severity="severity",date_log="date/time",version="version")
        if "/xyz/openbmc_project/logging/config/remote" in logs:
            address = logs["/xyz/openbmc_project/logging/config/remote"].get("Address",None)
            port = logs["/xyz/openbmc_project/logging/config/remote"].get("Port",None)
            output_config = "rsyslog server: {address:<15}:{port:>4}".format(address=address,port=port)
            self._display.display(output_config)
        self._display.display(output, color='bright blue')        
        logs_list = []
        for key, log in logs.items() :
            if not key.startswith('/xyz/openbmc_project/logging/entry/'):
                continue
            timestamp = log.get("Timestamp", None)
            if not timestamp:
                continue
            logs_list.append(log)
        logs_list.sort(key = lambda item: item["Timestamp"])
        for log in logs_list:
            id_log = log.get("Id", None)
            message = log.get("Message", None)
            purpose = log.get("Purpose", None)
            if purpose :
                purpose = purpose.replace('xyz.openbmc_project.Software.Version.VersionPurpose.','')
            resolved = log.get("Resolved", None)
            if resolved:
                resolved = "True"
            else:
                resolved = "False"
            severity = log.get("Severity", None)
            if severity :
                severity = severity.replace('xyz.openbmc_project.Logging.Entry.Level.','')
            timestamp = log.get("Timestamp", None)
            if timestamp :
                if import_tzlocal == True :
                    time_stamp = datetime.fromtimestamp(float(timestamp)/1000, tzlocal.get_localzone())
                else:
                    time_stamp = datetime.fromtimestamp(float(timestamp)/1000)
                timestamp = time_stamp.strftime('%Y-%m-%d %I:%M:%S %p %Z%z')
            version = log.get("Version", None)
            output = "{id_log:<5}{purpose:<10}{resolved:<10}{severity:<15}{timestamp:<33}{version:<15}{message:<}".format(id_log=id_log, message=message,purpose=purpose,resolved=resolved,severity=severity,timestamp=timestamp,version=version)
            if severity == "Notice":
                self._display.display(output, color='yellow')
                continue
            if severity == "Error":
                self._display.display(output, color='red')
                continue
            self._display.display(output, color='green')

    def _get_duration(self):
        end = datetime.now()
        total_duration = (end - self.tark_started)
        duration = total_duration.total_seconds() * 1000
        return duration

def getKey(item):
    return item[0]

