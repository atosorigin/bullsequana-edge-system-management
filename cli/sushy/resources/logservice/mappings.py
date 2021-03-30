# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

from sushy.resources.logservice import constants as log_cons
from sushy import utils


LOG_ENTRY_TYPE_VALUE_MAP = {
    'SEL': log_cons.LOG_ENTRY_SEL,
    'Multiple': log_cons.LOG_ENTRY_MULTIPLE,
    'Event': log_cons.LOG_ENTRY_EVENT,
    'OEM': log_cons.LOG_ENTRY_OEM
}

LOG_ENTRY_TYPE_VALUE_MAP_REV = (
    utils.revert_dictionary(LOG_ENTRY_TYPE_VALUE_MAP))

LOG_ENTRY_TYPE_VALUE_MAP_REV[log_cons.LOG_ENTRY_SEL] = 'SEL'
