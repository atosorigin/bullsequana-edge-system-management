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

# Values come from the Redfish LogService json-schema.
# https://redfish.dmtf.org/schemas/LogService.v1_1_3.json#/definitions/LogEntryType

from sushy.resources import constants as res_cons

# Log Entry Type constants

LOG_ENTRY_EVENT = res_cons.ENTRY_TYPE_EVENT
LOG_ENTRY_SEL = res_cons.ENTRY_TYPE_SEL
LOG_ENTRY_MULTIPLE = res_cons.ENTRY_TYPE_MULTIPLE
LOG_ENTRY_OEM = res_cons.ENTRY_TYPE_OEM
