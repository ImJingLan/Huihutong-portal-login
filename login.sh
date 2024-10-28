#!/bin/bash

# Login Script for f**king Huihutong Network
# Authored by Dustella Chan, distributed in AGPLv3
# https://github.com/Dustella

# Usage:
# 1. Set the environment variable OPEN_ID to your open id.
# $ export OPEN_ID="your_open_id"
# 2. Run the script
# $ bash login.sh
# 3. Optional: Set the environment variable NO_TRUST_PROXY to 'yes' if you don't trust the proxy.
# $ export NO_TRUST_PROXY="yes"

# Notices:
# Avoid using it over proxies, maybe timed out.

get_sa_token() {
    if [ -z "$OPEN_ID" ]; then
        echo "OPEN_ID environment variable is not set."
        echo "Please set \$OPEN_ID to your open id."
        exit 1
    fi

    url="https://api.215123.cn/web-app/auth/certificateLogin?openId=$OPEN_ID"
    response=$(curl -s "$url")
    echo "$response" | grep -oE '"token":"[^"]+"' | sed 's/"token":"//' | sed 's/"//g'
}

get_redir_url() {
    response=$(curl -s -o /dev/null -w "%{http_code}" -I "http://connect.rom.miui.com/generate_204")

    if [ "$response" -eq 204 ]; then
        echo Internet Access is Okay
        echo Internet Access is Okay
        # exit the whole program
        exit 0
    fi

    if [ "$response" -eq 302 ]; then
        location=$(curl -s -I "http://connect.rom.miui.com/generate_204" | grep -i "Location" | awk '{print \$2}' | tr -d '\r')
        echo "$location"
        return
    fi

    # if resp code is 200
    if [ "$response" -eq 200 ]; then
        html_content=$(curl -s "http://connect.rom.miui.com/generate_204")
        redir_url=$(echo "$html_content" | grep -oE "location\.href='(.*?)'" | grep -oE "'[^']+'" | sed "s/'//g" | tr -d "'\"")
        echo "$redir_url"
    fi
}

do_login() {
    local redir_url="$1"
    local sa_token="$2"

    if [ -z "$redir_url" ]; then
    echo "redir_url is empty"
        exit 1
    fi

    oauth_resp=$(curl -s -I "$redir_url")
    oauth_location=$(echo "$oauth_resp" | grep -i "Location" | awk '{print $2}' | tr -d '\r')

    pre_login_location="http://api.215123.cn/ac/auth/oauthRedirect?${oauth_location#*\?}&serviceName=chinaTelecom"
    pre_login_resp=$(curl -s -H "satoken: $sa_token" "$pre_login_location")

    final_login_url=$(echo "$pre_login_resp" | grep -oE '"data":"[^"]+"' | sed 's/"data":"//' |tr -d "'\"" )
    login_resp=$(curl -s -I "$final_login_url")

    login_result_url=$(echo "$login_resp" | grep -i "Location" | awk '{print $2}' | tr -d '\r')
    # if matched 'success' in the response url like 'http://10.10.16.101:8080/eportal/./success.jsp?userI', echo success
    login_result=$(echo "$login_result_url" | grep -oE 'success')
    curl -s -I "$login_result_url"
    echo "$login_result"
}

# unset http_proxy and https_proxy, if env: NO_TRUST_PROXY is 'yes'
if [ "$NO_TRUST_PROXY" = "yes" ]; then
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
fi

echo "Logging in..."
redir_url=$(get_redir_url)
sa_token=$(get_sa_token)
do_login "$redir_url" "$sa_token"
