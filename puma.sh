#!/bin/bash
# This script is Puma's bootstrap.
# You can move it into /etc/init.d/;
# You must change the configure variables which is uppercase in the frist time.
# Also u can send a email to me if u can't configure it.
#
# "Useage:"
# "$0 start|stop|restart|reload_nginx [appname]"
# "otherwise u must installed puma in the first, also u was make a rails app."
#
# author: tom.chen<viger@mchen.info> 
# and u can download my others bootstrap script on the github: https://github.com/viger/bootstrap
#################################################################################### 

ROOT_PATH=/home/vhosts/
CMD=$1
APP=$2
APP_ROOT="$ROOT_PATH$APP/"
CONFIG_PATH="${APP_ROOT}config/puma.rb"
SOCK_PATH="/var/run/"
SOCK_FILE="unix://${SOCK_PATH}puma_${APP}.sock"
PID_FILE="${APP_ROOT}tmp/pids/puma.pid"

set_path(){
    APP_ROOT="$ROOT_PATH$APP/"
    CONFIG_PATH="${APP_ROOT}config/puma.rb"
    SOCK_PATH="/var/run/"
    SOCK_FILE="unix://${SOCK_PATH}puma_${APP}.sock"
    PID_FILE="${APP_ROOT}tmp/pids/puma.pid"
}

check_app_name(){
    if test -n "$APP"; then
        echo ""
    else
        echo -e "please type in a app's name:"
        read APP
        set_path
    fi
}

check_path(){
    if [ ! -d "$APP_ROOT" ]; then
        echo -e "Not exists: ${APP_ROOT}.Can not start server."
        echo -n '.'
        exit 3;
    fi

    if [ ! -f "$CONFIG_PATH" ]; then
        echo -e "Not exists: ${CONFIG_PATH}, We will be start this server by this command:"
        echo -e "puma -d -b ${SOCK_FILE} -t 0:8 -w 1 "
        echo -n '.'
    fi

    if [ ! -d "$SOCK_PATH" ]; then
        echo -e "Not exists: ${SOCK_PATH}, Can not start server."
        echo -n '.'
        exit 3;
    fi
}

check_pid_file(){
    if [ ! -f "$PID_FILE" ]; then
        echo -e "Not exists: ${PID_FILE}, The server has be running?"
        echo -n '.'
        exit 3;
    fi
}

check_pid(){
    if [  -f "$PID_FILE" ]; then
        pid_num=`cat ${PID_FILE}`
        PS_NUM=`ps -p ${pid_num} | grep ${pid_num} | grep -v "grep" | wc -l`
        if [ $PS_NUM -eq 1 ]; then
            echo -e "The server has be running, please do not start it again, or u can restart it by this commnand:"
            echo -e "$0 restart $APP"
            exit 3;
        fi
    fi
}

stop_server(){
    check_pid_file

    echo -e "stop puma server..."
    kill -INT `cat ${PID_FILE}`
}

restart_server(){
    check_pid_file

    echo -e 'restart puma server...'
    kill -s SIGUSR2 `cat ${PID_FILE}`
}

reload_nginx_server(){
   echo -e "reload nginx ..."
   kill -HUP $(ps aux | grep 'nginx' | grep -v 'grep' | awk '{print $2}')
}

start_server(){
   check_app_name
   check_path
   check_pid

   echo -e "starting puma server...";
   if [ -f $CONFIG_PATH ]; then
       puma -C $CONFIG_PATH;
   else
       puma -d -w 1 -t 0:8 -b $SOCK_FILE
   fi
}

case "$CMD" in
    start)
        start_server
        echo "."
    ;;
    stop)
        stop_server
        echo "."
    ;;
    restart)
        restart_server
        echo "."
    ;;
    reload_nginx)
        reload_nginx_server
        echo "."
    ;;
    *)
        echo -e "Useage:"
        echo -e "$0 start|stop|restart|reload_nginx [appname]"
        echo -e ""
        echo -e "otherwise u must installed puma in the first, also u was make a rails app."
    ;;
esac
