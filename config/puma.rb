# You must replace 'app' to ur appname
APP_ROOT = '/home/vhosts/app'
pidfile "#{APP_ROOT}/tmp/pids/puma.pid"
state_path "#{APP_ROOT}/tmp/pids/puma.state"
bind "unix:///var/run/puma_app.sock"
daemonize true
workers 1
threads 0,16
#preload_app!
