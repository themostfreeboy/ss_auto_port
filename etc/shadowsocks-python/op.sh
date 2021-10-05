#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

function get_port() {
    local port=$(cat ${SCRIPT_DIR}/config.json 2>/dev/null | fgrep "server_port" 2>/dev/null | awk -F '"server_port":' '{print $2}' 2>/dev/null | awk -F ',' '{print $1}' 2>/dev/null)
    local ret=$?
    if [ ${ret} -eq 0 ]; then
        echo ${port}
    else
        echo "-1"
    fi

    return ${ret}
}

function set_port() {
    local MAX_SET_TIMES=3
    local rand_port="-1"
    local ret=0
    for ((i=0;i<${MAX_SET_TIMES};++i)); do
        rand_port=$((${RANDOM}%32768+10000))
        sed -e s/{PORT}/${rand_port}/g ${SCRIPT_DIR}/config.json.template >${SCRIPT_DIR}/config.json 2>/dev/null
        restart_service
        ret=$?
        if [ ${ret} -eq 0 ]; then
            echo ${rand_port}
            return 0
        fi
    done

    echo "-1"
    return ${ret}
}

function restart_service() {
    /usr/bin/python2 /usr/bin/ssserver -c /etc/shadowsocks-python/config.json -d stop &>/dev/null
    /usr/bin/python2 /usr/bin/ssserver -c /etc/shadowsocks-python/config.json -d start &>/dev/null
    return $?
}

$@
