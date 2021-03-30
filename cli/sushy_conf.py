import argparse
import logging
import warnings

warnings.filterwarnings("ignore")

parser=argparse.ArgumentParser(description="Python script using Redfish API to get logs.")
parser.add_argument('-ip', dest='ip', help='IP address', required=True)
parser.add_argument('-port', dest='port', help='port', required=False, default=443)
parser.add_argument('-u', dest='username', help='username', required=True)
parser.add_argument('-p', dest='password', help='password', required=True)
parser.add_argument('--verify', dest='verify', help='verify client certificate', required=False, default=False)
parser.add_argument('--noproxy', dest='noproxy', help='set no proxy', required=False, action='store_true')
parser.add_argument('--debug', dest='debug', help='debug level', required=False, action='store_false')
args=parser.parse_args()

log = logging.getLogger('sushy')
log.setLevel(logging.ERROR)
if args.debug:
    log.setLevel(logging.DEBUG)
log.addHandler(logging.StreamHandler())

