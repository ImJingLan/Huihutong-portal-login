import logging
from time import sleep

from login import do_login, get_redir_url, get_sa_token

log = logging.getLogger(__name__)

while True:
    sleep(5)
    try:
        redir_url = get_redir_url()
        if redir_url is None:
            log.info("Already logged in. Exiting")
            continue
        log.info("Not logged In, Got redir url", redir_url)
        satoken = get_sa_token()
        log.info("Got sa token", satoken)
        log.info("Doing Login....")
        try:
            do_login(redir_url, satoken)
        except Exception as e:
            log.error("Error when Logging in, ", e)
        finally:
            continue
        
    except Exception as e:
        log.error(e)
        continue