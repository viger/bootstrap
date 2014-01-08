#!/bin/bash
# This script is Rails's bootstrap.
# You can move it into /etc/init.d/;
# You must change the configure variables which is uppercase in the frist time.
# Also u can send a email to me if u can't configure it.
#
# "Useage: "
# "$0 [start|stop|restart|log] appname port[default: 3000]"
# 
# "You can read the log of the app's in $LOG_PATH, the log file name is similler the app's name."
#
# author: tom.chen<viger@mchen.info> 
# and u can download my others bootstrap script on the github: https://github.com/viger/bootstrap
#################################################################################### 


APP=$2
PORT=$3
CMD=$1
APP_ROOT_PATH=/home/vhosts/
LOG_PATH=/home/vhosts/railserverlog/
APP_PID_FILE=/tmp/pids/server.pid

chk_log_path(){
    if [ ! -d $LOG_PATH ]; then
        mkdir $LOG_PATH;
        chmod -R 777 $LOG_PATH;
    fi
}

chk_nil_port(){
    if [ ! $PORT ]; then
        echo -n "Your not defined custom prot, the port will be defined to  3000.";
        echo ".";
        PORT=3000;
    fi
}

start_server(){
        chk_log_path
        chk_nil_port
        if [ ! -d $APP_ROOT_PATH$APP ]; then
            echo "Can not find the Application Path: $APP_ROOT_PATH$APP.";
            echo ".";
            exit 3;
        else
            cd $APP_ROOT_PATH$APP;
            echo -n "Starting Rails Server on port $PORT for Application $APP.";
            rails s -p $PORT 2>&1 1> "$LOG_PATH$APP.log" &
        fi
}

stop_server(){
    pid_file= $APP_ROOT_PATH$APP$APP_PID_FILE
    if [ -f $pid_file ]; then
        kill -INT `cat $pid_file` || echo -n "rails server is stoped."
    else
        echo "Can not found the pid file, rails is not running?"
        echo "."
        exit 3;
    fi
}

restart_server(){
    pid_file= $APP_ROOT_PATH$APP$APP_PID_FILE
    if [ -f $pid_file ]; then
        kill -HUP `cat $pid_file` || echo -n "rails server is reload."
    else
        echo "Can not found the pid file, rails is not running?"
        echo "."
        exit 3;
    fi
}

tail_log(){
        chk_log_path
        if [ ! -f "$LOG_PATH$APP.log" ]; then
            echo "This Application $APP was not runing or the log file is missing.";
            echo ".";
            exit 3;
        fi
        tail -f "$LOG_PATH$APP.log";
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
        stop_server
        start_server
        echo "."
    ;;
    log)
        tail_log
        echo "."
    ;;
    *)
        echo -n "Useage: "
        echo -n "$0 [start|stop|restart|log] appname port[default: 3000]"
        echo "."
        echo -n "You can read the log of the app's in $LOG_PATH, the log file name is similler the app's name."
        echo "."
        exit 3
        ;;
esac
exit 0;
