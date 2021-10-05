#!/bin/env python
# coding:utf-8

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import flask
import os

app = flask.Flask(__name__)

@app.route("/get_port", methods=["GET", "POST"])
def get_port():
    try:
        ret = os.popen('cd /etc/shadowsocks-python && sh op.sh get_port').readlines()
        if len(ret) == 1:
            port = ret[0].strip()
            return port
    except Exception, e:
        app.logger.error(str(type(e)) + ':' + str(e))
    return "fail"

@app.route("/set_port", methods=["GET", "POST"])
def set_port():
    try:
        ret = os.popen('cd /etc/shadowsocks-python && sh op.sh set_port').readlines()
        if len(ret) == 1:
            port = ret[0].strip()
            return port
    except Exception, e:
        app.logger.error(str(type(e)) + ':' + str(e))
    return "fail"

if __name__ == "__main__":
    try:
        app.config["JSON_AS_ASCII"] = False
        app.run(host="0.0.0.0", port=8080, debug=False)
    except Exception, e:
        app.logger.error(str(type(e)) + ':' + str(e))
