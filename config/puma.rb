APP_ROOT = '/home/vhosts/tao800_fire'
pidfile "#{APP_ROOT}/tmp/pids/puma.pid"
state_path "#{APP_ROOT}/tmp/pids/puma.state"
bind "unix:///var/run/puma_tao800_fire.sock"
daemonize true
workers 1
threads 0,16
#preload_app!
