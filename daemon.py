import logging
from time import sleep

from login import do_login, get_redir_url, get_sa_token
import argparse

# make it print time
logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)

parser = argparse.ArgumentParser(description='Daemon for portal login.')
parser.add_argument('--interval', type=int, default=5, help='Interval between login attempts in seconds.')
parser.add_argument('--log-file', type=str, help='File to log output.')

args = parser.parse_args()

if args.log_file:
    logging.basicConfig(filename=args.log_file, format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)
else:
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)

interval = args.interval


while True:
    sleep(interval)
    try:
        redir_url = get_redir_url()
        if redir_url is None:
            logging.info("Already logged in. Exiting")
            continue
        logging.info("Not logged In, Got redir url", redir_url)
        satoken = get_sa_token()
        logging.info("Got sa token", satoken)
        logging.info("Doing Login....")
        try:
            do_login(redir_url, satoken)
        except Exception as e:
            logging.error("Error when Logging in, ", e)
        finally:
            continue
        
    except Exception as e:
        logging.error(e)
        continue