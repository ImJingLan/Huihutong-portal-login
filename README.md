# Huihutong-portal-login
慧湖通 2024 自动登录脚本 - 无需扫码、完全无人值守、支持 Openwrt

# 功能:

- [x] 无需扫码
- [x] 完全无人值守
- [x] 支持 Openwrt

# 使用方法:

## Bash 版本

Bash 版本代码在 `login.sh` 文件中。已经测试过在 Openwrt、Ubuntu、WSL2 甚至 Msys2 上可以正常运行，甚至 系统 grep 可以没有 Perl 正则表达式支持也能工作。(需要有：`curl`, `awk`, `tr`, `grep`, `sed` 等工具)

1. 通过抓包得到 OpenID

你应当参考这个项目的 README.md 来获取 OpenID:

https://github.com/PairZhu/HuiHuTong

2. 设置环境变量 OPEN_ID
```
 $ export OPEN_ID="your_open_id"
 ```

3. 运行脚本
```
 $ bash login.sh
```

4. 你可以通过设置环境变量 NO_TRUST_PROXY 来禁用代理。
```
 $ export NO_TRUST_PROXY="yes"
```

## Python 版本

Python 版本代码在 `login.py` 文件中。已经测试过在 WSL2 和 Windows 上可以正常运行。(需要有：`requests`)

1. 同上通过抓包得到 OpenID

2. 设置环境变量 OPEN_ID
```
 $ export OPEN_ID="your_open_id"
 ```

 如果你在用windows，你需要用Powershell，命令如下：
```
 $env:OPEN_ID="your_open_id"
```

3. 运行脚本
```
 $ python login.py
```
# 注意事项:

尽量不要用代理，因为代理可能会导致登录失败。

# Author:

Dustella, contact me at https://github.com/Dustella

# Credits

credits to [PairZhu](https://github.com/PairZhu) for the reference of satoken API.

credits to [TianxinZhao](https://github.com/TianxinZhao/HuiHuBuTong) for the mecanism of login.

# License


AGPL-3.0