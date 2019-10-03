# coding=utf-8
# pylint: disable=I0011,E0401,C0103,C0111,W0212

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import sys
from datetime import datetime

try:
    from ansible.utils.color import colorize, hostcolor
    from ansible.plugins.callback import CallbackBase
except ImportError:
    class CallbackBase:
        # pylint: disable=I0011,R0903
        pass

# import unittest

# Fields we would like to see before the others, in this order, please...
PREFERED_FIELDS = ['stdout', 'rc', 'stderr', 'start', 'end', 'msg']
# Fields we will delete from the result
DELETABLE_FIELDS = [
    'stdout', 'stdout_lines', 'rc', 'stderr', 'start', 'end', 'msg',
    '_ansible_verbose_always', '_ansible_no_log', 'invocation', '_ansible_parsed',
    '_ansible_item_result', '_ansible_ignore_errors', '_ansible_item_label']

CHANGED = 'yellow'
UNCHANGED = 'green'


def deep_serialize(data, indent=0):
    # pylint: disable=I0011,E0602,R0912,W0631

    padding = " " * indent * 2
    if isinstance(data, list):
        if data == []:
            return "[]"
        output = ""
        if len(data) == 1:
            output = output + \
                ("\n" +
                 padding).join(deep_serialize(data[0], 0).splitlines()) + " ]"
        else:
            list_padding = " " * (indent + 1) * 2

            for item in data:
                output = output + "\n" + list_padding + "" + \
                    deep_serialize(item, indent)
            output = output + "\n" + padding
    elif isinstance(data, dict):
        if "_ansible_no_log" in data and data["_ansible_no_log"]:
            data = {"censored":
                    "the output has been hidden due to the fact that"
                    " 'no_log: true' was specified for this result"}
        list_padding = " " * (indent + 1) * 2
        output = "\n"

        for key in PREFERED_FIELDS:
            if key in data.keys():
                value = data[key]
                prefix = list_padding + "%s: " % key
                output = output + prefix + "%s" % \
                    "\n".join([" " * len(prefix) + line
                               for line in deep_serialize(value, indent)
                               .splitlines()]).strip()

        for key in DELETABLE_FIELDS:
            if key in data.keys():
                del data[key]

        for key, value in data.items():
            output = output + list_padding + \
                "%s: %s\n" % (key, deep_serialize(value, indent + 1))

        output = output + padding
    else:
        string_form = str(data)
        if len(string_form) == 0:
            return "\"\""
        else:
            return string_form
    return output

def getKey(item):
    return item[0]

class CallbackModule(CallbackBase):

    '''
    This is the default callback interface, which simply prints messages
    to stdout when new callback events are received.
    '''

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'anstomlog'

    # get_sensors.yml
    def deep_serialize_sensors(self, data):
        # pylint: disable=I0011,E0602,R0912,W0631
        
        if not isinstance(data, dict):
            return "[not a dict]"
        if data == []:
            return "[]"
        sensors = data.get("sensors", None)
        output = "{header_key:<40}:{header_value:>10}{header_crit_low:>10}{header_crit_high:>10}".format(header_key="name", header_value="current",header_crit_low="crit low",header_crit_high="crit high")
        self._display.display(output, color='bright blue')
        sorted_sensors = sorted(sensors.iteritems(), key=getKey)
        for (key, sensor) in sorted_sensors:
            value = sensor.get("Value", None)
            crit_low = sensor.get("CriticalLow", None)
            crit_high = sensor.get("CriticalHigh", None)
            output = "{key:<40}:{value:>10}{crit_low:>10}{crit_high:>10}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value,crit_low=crit_low,crit_high=crit_high)
            color = 'green'
            if int(value) < int(crit_low) :
                color='red'
            if int(value) > int(crit_high) :
                color='red'            
            self._display.display(output, color=color)

    # check_critical_high_low_sensors.yml
    def deep_serialize_sensors_alarms(self, data):
        # pylint: disable=I0011,E0602,R0912,W0631
        
        if not isinstance(data, dict):
            return "[not a dict]"
        if data == []:
            return "[]"
        sensors = data.get("sensors", None)
        output = "{header_key:<40}:{header_value:>10}{header_crit:>20}".format(header_key="name", header_value="current",header_crit="crit low/high")
        self._display.display(output, color='bright blue')
        sorted_sensors = sorted(sensors.iteritems(), key=getKey)
        for (key, sensor) in sorted_sensors:
            value = sensor.get("Value", None)
            crit_low = sensor.get("CriticalLow", None)
            crit_high = sensor.get("CriticalHigh", None)
            if int(value) < int(crit_low) :
                output = "{key:<40}:{value:>10}   < {crit_low:>10} = {comment:>10}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value,crit_low=crit_low,comment="too low !!")
                self._display.display(output, color='red')
            if int(value) > int(crit_high) :
                output = "{key:<40}:{value:>10}   > {crit_high:>10} = {comment:>10}".format(key=key.replace("/xyz/openbmc_project/sensors/",""),value=value,crit_high=crit_high,comment="too high !!")
                self._display.display(output, color='red')            

    def _get_duration(self):
        end = datetime.now()
        total_duration = (end - self.tark_started)
        duration = total_duration.total_seconds() * 1000
        return duration

    def v2_playbook_on_task_start(self, task, is_conditional):
        # pylint: disable=I0011,W0613
        #sys.stdout.write("\n*****************{}\n" + task.get_name())
        if task.get_name() == 'include_tasks':
            return
        if task.get_name() == 'system':
            return
        self._open_section(task.get_name(), task.get_path())
        self._task_level += 1

    def _open_section(self, section_name, path = None):
        if section_name == 'debug':
            return
        # pylint: disable=I0011,W0201        
        self.tark_started = datetime.now()
        prefix = ''
        if self._task_level > 0:
            prefix = '  ➥'

        ts = self.tark_started.strftime("%H:%M:%S")
        if self._display.verbosity > 1:
            if path:
                self._emit_line("[{}]: {}".format(ts, path))
        self.task_start_preamble = "[{}]{} {} ...".format(ts , prefix, section_name)
        sys.stdout.write(self.task_start_preamble)

    def v2_playbook_on_handler_task_start(self, task):
        self._emit_line("triggering handler | %s " % task.get_name().strip())

    def v2_runner_on_failed(self, result, ignore_errors=False):
        # pylint: disable=I0011,W0613,W0201
        duration = self._get_duration()
        host_string = self._host_string(result)
        self._task_level = 0

        if 'exception' in result._result:
            exception_message = "An exception occurred during task execution."
            if self._display.verbosity < 3:
                # extract just the actual error message from the exception text
                error = result._result['exception'].strip().split('\n')[-1]
                msg = exception_message + \
                    "To see the full traceback, use -vvv. The error was: %s" % error
            else:
                msg = exception_message + \
                    "The full traceback is:\n" + \
                    result._result['exception'].replace('\n', '')

                self._emit_line(msg, color='red')

        self._emit_line("%s | FAILED | %dms" %
                        (host_string,
                         duration), color='red')
        self._emit_line(deep_serialize(result._result), color='red')

    def v2_on_file_diff(self, result):

        if result._task.loop and 'results' in result._result:
            for res in result._result['results']:
                if 'diff' in res and res['diff'] and res.get('changed', False):
                    diff = self._get_diff(res['diff'])
                    if diff:
                        self._emit_line(diff)

        elif 'diff' in result._result and \
                result._result['diff'] and \
                result._result.get('changed', False):
            diff = self._get_diff(result._result['diff'])
            if diff:
                self._emit_line(diff)

    def _host_string(self, result):
        delegated_vars = result._result.get('_ansible_delegated_vars', None)

        if delegated_vars:
            host_string = "%s -> %s" % (
                result._host.get_name(), delegated_vars['ansible_host'])
        else:
            host_string = result._host.get_name()

        return host_string

    def v2_runner_on_ok(self, result):
        # pylint: disable=I0011,W0201,
        #sys.stdout.write("\n*****************{}\n" + result._task.action)
            
        self._clean_results(result._result, result._task.action)

        host_string = self._host_string(result)

        self._clean_results(result._result, result._task.action)

        self._task_level = 0

        if result._task.action in ('include', 'include_role'):
            sys.stdout.write("\b\b\b\b    \n")
            return

        if result._task.action == 'include_tasks':
            return

        #if result._task.action == 'system':
        #    return

        if result._task.action == 'system':
            sys.stdout.write("\b\b\b\b    \n")
            return
                
        msg, color = self._changed_or_not(result._result, host_string)
        duration = self._get_duration()
            
        if 'Render sensors' in result._task.name:   
            self._emit_line("\n%s | %dms" % (msg, duration), color=color)   
            self.deep_serialize_sensors(result._result)
            return
        if 'Check Critical Sensor Alarms' in result._task.name:
            self._emit_line("\n%s | %dms" % (msg, duration), color=color)   
            self.deep_serialize_sensors_alarms(result._result)
            return
        if 'Render json' in result._task.name:   
            self._emit_line("\n%s | %dms" % (msg, duration), color=color)   
            self._emit_line(deep_serialize(result._result), color=color)
            return
        if 'Render' in result._task.name:
            name = result._task.name.split('Render ')
            if len(name) == 2:
                variable = name[1]
                self._emit_multiple_result_line("%s | %dms = %s" % (msg, duration, result._result[variable]), color=color)
                return
            self._emit_line("%s | %dms = %s" % (msg, duration, result._result), color=color)
            return

        if result._task.loop and self._display.verbosity > 0 and 'results' in result._result:
            for item in result._result['results']:
                msg, color = self._changed_or_not(item, host_string)
                item_msg = "%s - item=%s" % (msg, self._get_item(item))
                self._emit_line("%s | %dms" % (item_msg, duration), color=color)
        else:
            self._emit_line("%s | %dms | " % (msg, duration), color=color)
        
        self._handle_warnings(result._result)
        
        if self.task_start_preamble.endswith(" ..."):
            sys.stdout.write("\b\b\b\b     \n")
            self.task_start_preamble = " "

        result._preamble = self.task_start_preamble

        # default
        if ( self._display.verbosity > 0 or '_ansible_verbose_always' in result._result) and not '_ansible_verbose_override' in result._result:
            self._emit_line(deep_serialize(result._result), color=color)        

    def _changed_or_not(self, result, host_string):
        if result.get('changed', False):
            msg = "%s | CHANGED" % host_string
            color = CHANGED
        else:
            msg = "%s | SUCCESS" % host_string
            color = UNCHANGED

        return [msg, color]

    def _emit_multiple_result_line(self, line, color='normal'):

        if self.task_start_preamble is None:
            self._open_section("system")

        if self.task_start_preamble.endswith(" ..."):
            sys.stdout.write("\b\b\b\b |  \n")
            self.task_start_preamble = " "

        self._display.display(line, color=color)

    def _emit_line(self, lines, color='normal'):

        if self.task_start_preamble is None:
            self._open_section("system")

        if self.task_start_preamble.endswith(" ..."):
            sys.stdout.write("\b\b\b\b | \n")
            self.task_start_preamble = " "

        for line in lines.splitlines():
            self._display.display(line, color=color)

    def v2_runner_on_unreachable(self, result):
        self._task_level = 0
        self._emit_line("%s | UNREACHABLE!: %s" %
                        (self._host_string(result), result._result.get('msg', '')), color=CHANGED)

    def v2_runner_on_skipped(self, result):
        duration = self._get_duration()
        self._task_level = 0

        self._emit_line("%s | SKIPPED | %dms" %(self._host_string(result), duration), color='cyan')

    def v2_playbook_on_include(self, included_file):
        self._open_section("system")

        msg = 'included: %s for %s' % \
            (included_file._filename, ", ".join(
                [h.name for h in included_file._hosts]))
        self._emit_line(msg, color='cyan')

    def v2_playbook_on_stats(self, stats):
        self._open_section("system")
        self._emit_line("-- Play recap --")

        hosts = sorted(stats.processed.keys())
        for h in hosts:
            t = stats.summarize(h)

            self._emit_line(u"%s : %s %s %s %s" % (
                hostcolor(h, t),
                colorize(u'ok', t['ok'], UNCHANGED),
                colorize(u'changed', t['changed'], CHANGED),
                colorize(u'unreachable', t['unreachable'], CHANGED),
                colorize(u'failed', t['failures'], 'red')))

    def __init__(self, *args, **kwargs):
        super(CallbackModule, self).__init__(*args, **kwargs)
        self._task_level = 0
        self.task_start_preamble = None
        # python2 only
        try:
            reload(sys).setdefaultencoding('utf8')
        except:
            pass