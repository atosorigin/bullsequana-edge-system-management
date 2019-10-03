# Copyright: (c) 2019, Francine Sauvage <@fsauvage>

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    callback: atosunixy
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
from os.path import basename
from datetime import datetime
from ansible import constants as C
from ansible import context
from ansible.module_utils._text import to_text
from ansible.parsing.yaml.dumper import AnsibleDumper
from ansible.utils.color import colorize, hostcolor
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
    CALLBACK_NAME = 'atosunixy'

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
        task_result = "[{task_time}] {host} | {duration:>8}ms".format(task_time=ts, host=task_host, duration=self._get_duration())
        # Sensors
        sensors = result._result.get("sensors", None)         
        if sensors:          
            self.deep_serialize_sensors(task_result, sensors, False)
            return
        # Sensors
        #sensors = result._result.get("check_sensors", None)         
        #if sensors:          
        #    self.deep_serialize_sensors(task_result, sensors, True)
        #    return
        
        # Upload
        if result._result.get('url') and result._result.get('msg') and "/upload/image" in result._result.get('url') :
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

            data_description = json_data.get('description', None)

            if data_description: 
                task_result += " | " + to_text(data_description)
                self._display.display(task_result, display_color, stderr=err)
                return
            # else = return default msg
            task_result += " | " + to_text(result._result.get('msg', None))
            self._display.display(task_result, display_color, stderr=err)
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
        
        task_result = "[{task_time}] {host} | {duration:>8}ms".format(task_time=ts, host=task_host, duration=self._get_duration())
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
    def deep_serialize_sensors(self, name, sensors, check=False):
        output = "{header_key:<40}:{header_value:>10}{header_crit_low:>10}{header_crit_high:>10}".format(header_key=name+" | sensors", header_value="current",header_crit_low="crit low",header_crit_high="crit high")
        self._display.display(output, color='bright blue')
        sorted_sensors = sorted(sensors.iteritems(), key=getKey)
        for (key, sensor) in sorted_sensors:
            value = sensor.get("Value", None)
            crit_low = sensor.get("CriticalLow", None)
            crit_high = sensor.get("CriticalHigh", None)
            output = "{key:<40}:{value:>10}{crit_low:>10}{crit_high:>10}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value,crit_low=crit_low,crit_high=crit_high)
            if int(value) < int(crit_low) :
                self._display.display(output, color='red')
            else:
                if not check:
                    self._display.display(output, color='green')

            if int(value) > int(crit_high) :
                self._display.display(output, color='red')
                if not check:
                    self._display.display(output, color='green')

    def _get_duration(self):
        end = datetime.now()
        total_duration = (end - self.tark_started)
        duration = total_duration.total_seconds() * 1000
        return duration

def getKey(item):
    return item[0]

