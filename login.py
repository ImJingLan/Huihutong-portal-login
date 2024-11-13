from requests import Session
import re
import os

session = Session()
session.trust_env = False
open_id = os.getenv("OPEN_ID")


def get_sa_token():
    url = f'https://api.215123.cn/web-app/auth/certificateLogin?openId=${open_id}'
    resp = session.get(url, )
    return resp.json()["data"]["token"]


def get_redir_url():
    try:
        resp = session.get("http://connect.rom.miui.com/generate_204", allow_redirects=False)
    except Exception as e:
        raise Exception("Timed out. No Internet Connection", e)
    
    code = resp.status_code
    if code == 204:
        print("Already logged in. Exiting")
        return None
    
    if code == 302:
        return resp.headers["Location"]
    
    if code == 200:
        html_content = resp.content.decode("utf-8")
        
        pattern = r"location\.href='(.*?)'"
        redir_url = re.findall(pattern, html_content)[0]
        
        return redir_url
    


def do_login(redir_url, sa_token):
    if redir_url is None:
        return
    oauth_resp = session.get(redir_url, allow_redirects=False)

    oauth_location =  "https://api.215123.cn/ac/auth/oauthRedirect?" + oauth_resp.headers["location"].split("?")[1] + "&serviceName=chinaTelecom"

    login_resp = session.get(oauth_location, headers={"satoken": sa_token})
    
    final_login_url = login_resp.json()["data"]
    resp = session.get(final_login_url)
    
    print(resp)


if __name__ == "__main__":
    try:
        redir_url = get_redir_url()
        if redir_url is None:
            exit(0)
        sa_token = get_sa_token()
        do_login(redir_url, sa_token)
        
    except Exception as e:
        raise e
    
