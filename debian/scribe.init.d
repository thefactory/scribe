#! /bin/sh
### BEGIN INIT INFO
# Provides:          scribe
# Required-Start:    $remote_fs $network $named
# Required-Stop:     $remote_fs $network $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start scribe daemon on boot
# Description:       Scribe daemon.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/scribed
NAME=scribe
DESC=scribe
PIDFILE="/var/run/scribe.pid"
DAEMON_OPTS="-c /etc/scribe/scribe.conf"
SCRIBE_CTRL=/usr/bin/scribe_ctrl

test -x $DAEMON || exit 0

# Include scribe defaults if available
if [ -f /etc/default/scribe ] ; then
	. /etc/default/scribe
fi

set -e

case "$1" in
  start)
	echo -n "Starting $DESC: "
	start-stop-daemon --start --pidfile "$PIDFILE" -m --chuid "scribe" --quiet --oknodo --background --exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon --stop --oknodo --pidfile "$PIDFILE" --user "scribe" --verbose --retry=TERM/30/KILL/5
	echo "$NAME."
	;;
  reload)
	echo "Reloading $DESC configuration files."
	if [ -f "$PIDFILE" ]; then
		kill -s USR1 `cat $PIDFILE`
	fi
	;;
  status)
	if [ -f "$PIDFILE" ]; then
		ps -p `cat $PIDFILE` > /dev/null
		exit $?
	fi
	exit 1
	;;
  restart)
	echo -n "Restarting $DESC: "
	$0 stop && sleep 2 && $0 start
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|status|restart|reload}" >&2
	exit 1
	;;
esac

exit 0
