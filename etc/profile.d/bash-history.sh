HISTBASEDIR=/var/log/bashhist

# Sanity checks
# Maybe these checks should write to syslog rather than just echoing
if ! [ -d $HISTBASEDIR ]; then
	echo "Bash history shim broken, $HISTBASEDIR missing"
fi

# are we an interactive shell?
if [ "$PS1" ] && [ -d $HISTBASEDIR ]; then

	case `uname` in

		Darwin)
			DIRPERMS=`stat -f "%Mp%Lp" $HISTBASEDIR`
			;;
		Linux)
			DIRPERMS=`stat -c %a $HISTBASEDIR`
			;;
		*)
			DIRPERMS=0
			;;
	esac

	if [ "$DIRPERMS" -ne 1777 ]; then
		echo "Permissions on $HISTBASEDIR not quite right"
	fi

	
        REALNAME=`who -m | awk '{ print $1 }'`

	# There's a bug in tmux apparently where older versions do not do the needful
	# for making sure who -m returns the right value
	# see https://stackoverflow.com/questions/27400059/tmux-breaks-who-am-i-who-m
	# Note this bug exists in RHEL 7.6 and (I assume) below tmux
	if [ "x$REALNAME" == "x" ]; then
		echo "REALNAME not set, using 'unknown'"
		REALNAME='unknown'
	fi
	
        EFFNAME=`id -un`
        mkdir -m 700 $HISTBASEDIR/$EFFNAME >/dev/null 2>&1

        shopt -s histappend
        shopt -s lithist
        shopt -s cmdhist

        unset  HISTCONTROL && export HISTCONTROL
        unset  HISTIGNORE && export HISTIGNORE
        export HISTSIZE=10000
        export HISTTIMEFORMAT="%F %T "
        export HISTFILE=$HISTBASEDIR/$EFFNAME/history-$REALNAME
	declare -rx HISTSIZE HISTTIMEFORMAT HISTFILE HISTCONTROL HISTIGNORE

	case "$TERM_PROGRAM" in

		iTerm.app*)
			WINDOW_TITLE_UPDATE='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
			;;

		*)
			WINDOW_TITLE_UPDATE=''
			;;
	esac

	if [ "x$TMUX" != "x" ]; then
		WINDOW_TITLE_UPDATE='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
	fi

###	case $TERM in
###		xterm*)
###			#PROMPT_COMMAND='history -a && printf "\033k;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
###			PROMPT_COMMAND='history -a ; printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
###			;;
###		screen)
###			#PROMPT_COMMAND='history -a && printf "\033k;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
###			PROMPT_COMMAND='history -a ; printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
###			;;
###		*)
###			PROMPT_COMMAND='history -a'
###			;;
###	esac

	PROMPT_COMMAND="history -a ; $WINDOW_TITLE_UPDATE"

	# Turn on checkwinsize
	shopt -s checkwinsize
	PS1="[\u@\h \W]\\$ "
fi
