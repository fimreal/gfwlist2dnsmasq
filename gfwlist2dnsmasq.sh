#!/usr/bin/env bash

set -e

# 日志格式化
BLDRED='\033[1;31m' # Red
BLDGRN='\033[1;32m' # Green
BLDMGT='\033[1;35m' # Magenta
TXTRST='\033[0m'    # White

Info() {
    printf "%b\n" "${BLDGRN}[INFO]${TXTRST} $1"
}
Warn() {
    printf "%b\n" "${BLDMGT}[WARN]${TXTRST} $1"
}
Err() {
    printf "%b\n" "${BLDRED}[ERROR]${TXTRST} $1"
}

ErrExit() {
    [ $1 -eq 0 ] && return || Err "${@:2}"
    rm -rf $TMP_DIR
    exit $1
}

# 绑定参数
mirror='gitlab'
dstFile="$PWD/gfwlist.conf"
unset ipset
unset extraFile
reslover="127.0.0.1#53"

while [ $# -gt 0 ]; do
    case "$1" in
    --mirror)
        mirror="$2"
        Info "--mirror: ${mirror}"
        shift
        ;;
    --dstfile)
        dstFile="$2"
        Info "--dstFile: ${dstFile}"
        shift
        ;;
    --extrafile)
        extraFile="$2"
        Info "--extraFile: ${extraFile}"
        shift
        ;;
    --ipset)
        ipset="$2"
        Info "--ipset: ${ipset}"
        shift
        ;;
    --reslover)
        reslover="$2"
        Info "--reslover: ${reslover}"
        shift
        ;;
    --*)
        ErrExit 1 "Illegal option $1"
        ;;
    esac
    shift $(($# > 0 ? 1 : 0))
done

# 选择获取 gfwlist 地址
Download_URL=""
case "$mirror" in
github)
    Download_URL="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt"
    ;;
gitlab)
    Download_URL="https://gitlab.com/gfwlist/gfwlist/raw/master/gfwlist.txt"
    ;;
pagure)
    Download_URL="http://repo.or.cz/gfwlist.git/blob_plain/HEAD:/gfwlist.txt"
    ;;
bitbucket)
    Download_URL="https://bitbucket.org/gfwlist/gfwlist/raw/HEAD/gfwlist.txt"
    ;;
tuxfamily)
    Download_URL="https://git.tuxfamily.org/gfwlist/gfwlist.git/plain/gfwlist.txt"
    ;;
*)
    Download_URL="${mirror}"
    ;;
esac

# 检查命令是否存在
commandExists() {
    command -v "$@" &>/dev/null
}

httpGet() {
    if commandExists curl; then
        DOWNLOADER="curl"
    elif commandExists wget; then
        DOWNLOADER="wget"
    else
        ErrExit 2 'this script needs command to download gfwlist file. it is unable to find either "curl" or "wget" available to make this happen'
    fi
    case ${DOWNLOADER} in
    curl)
        curl -sfL $1
        ;;
    wget)
        wget -qO- $1
        ;;
    esac
    [ $? == 0 ] && return || ErrExit $? "error occurs when downloading gfwlist file"
}

# 下载文件并格式化
# 语法参考：https://github.com/gfwlist/gfwlist/wiki/Syntax
# ｜ 开头，匹配以某段字符串开头或者结尾，包括 uri 和 scheme
# || 开头，匹配任何协议，后面通常不写 scheme，只包含域名和或者子域名
# ! 开头为注释
# @@ 或者 . 开头为白名单匹配
#
# gfwlist 里有很多垃圾匹配规则，默认 || 即可
Info "开始下载并处理源文件"
# 取出域名
Domains="$(httpGet ${Download_URL} | base64 -d | awk -F '|' '/^\|\|/{print $3}')"

conv() {
    if [ "${reslover}" != "none" ]; then
        printf "server=/%s/%s\n" $1 ${reslover}
    fi
    if [ -n "${ipset}" ]; then
        printf "ipset=/%s/%s\n" $1 ${ipset}
    fi
}

# 清空/创建文件
>${dstFile}
# 把域名转换为 dnsmasq 格式追加写入文件
for d in ${Domains}; do
    conv $d >>${dstFile}
done

# Info "添加自定义域名"
if [ -n "${extrafile}" ]; then
    echo -e "\n# custom domain" >>${dstFile}
    for d in $(cat ${extraFile}); do
        conv $d >>${dstFile}
    done
fi

# 去重
awk '@include "inplace";!a[$0]++' ${dstFile}
