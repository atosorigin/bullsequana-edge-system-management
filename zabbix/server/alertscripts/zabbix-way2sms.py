#!/usr/bin/env python
# -*- coding: utf-8 -*-

############################
#
# OpenBMC Collector for Zabbix
#
# This script will be able to collect information from OpenBMC Mipocket
#
# by francine.sauvage@atos.net
#
#

import sys
import way2sms

def send_way2sms(from_, to_):
  sms=way2sms.sms(username,password)
  return sms

def main(args):
  parser = argparse.ArgumentParser(description="This script will be able to collect information from OpenBMC Mipocket")
  parser.add_argument("-f", "--from_", dest="from_", help="SMS phone number of the free text server like twilio", required=True)
  parser.add_argument("-t", "--to_", dest="to_", help="destination phone number", required=True)
  args = parser.parse_args()
  res = send_twilio(args.from_, args.to_)
  print(res)

main(sys.argv)