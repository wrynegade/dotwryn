#####################################################################

DEPENDENCIES+=(yq)

#####################################################################

REMOTE__GET_CONNECTION_STRING() {
	local REMOTE_NAME="$1"
	[ $(REMOTE__QUERY_CONNECTION .sessions.$REMOTE_NAME.host) ] \
		|| ERROR "no such connection $REMOTE_NAME exists" \
		|| return 1

	local CONNECTION_HOST=$(REMOTE__QUERY_CONNECTION .sessions.$REMOTE_NAME.host)
	[ $CONNECTION_HOST ] \
		|| ERROR "connection $REMOTE_NAME is misconfigured; missing 'host' field" \
		|| return 1

	local CONNECTION_USER=$(REMOTE__QUERY_CONNECTION .sessions.$REMOTE_NAME.user)
	[ $CONNECTION_USER ] || CONNECTION_USER=$(REMOTE__QUERY_CONNECTION .default.user)

	[ $CONNECTION_USER ] \
		&& CONNECTION_STRING="${CONNECTION_USER}@${CONNECTION_HOST}" \
		|| CONNECTION_STRING="$CONNECTION_HOST" \
		;

	echo $CONNECTION_STRING
}

REMOTE__GET_SSH_ARGS() {
	local REMOTE_NAME
	local TYPE=ssh
	local USE_TTY=true

	while [[ $# -gt 0 ]]
	do
		case $1 in
			-t | --type ) TYPE=$2;    shift 1 ;;
			--use-tty   ) USE_TTY=$2; shift 1 ;;

			--no-tty ) USE_TTY=false ;;

			* )
				[ $REMOTE_NAME ] && { ERROR "too many args :c"; return 1; }
				REMOTE_NAME=$1
				;;
		esac
		shift 1
	done

	local ARGS=()
	[ $REMOTE_NAME ] || {
		echo "${ARGS[@]}"
		return 0
	}

	local PORT=$(REMOTE__QUERY_CONNECTION .sessions.$REMOTE_NAME.port)

	[ $PORT ] && {
		case $TYPE in
			ssh | xserver | tmux ) ARGS+=(-p $PORT) ;;
			scp ) ARGS+=(-P $PORT) ;; # not really in use, just a sample
			* ) 
				WARNING " 
					port is specified, but I'm not sure whether to use '-p' or '-P'

					if this command fails, try adding your --type to the appropriate
					list in '$SCWRYPTS_ROOT__remote/lib/config.module.zsh'
				 "
				ARGS+=(-p $PORT)
				;;
		esac
	}

	ARGS+=($(REMOTE__QUERY_CONNECTION .session.$REMOTE_NAME.$TYPE.args))

	[[ $USE_TTY =~ true ]] && ARGS+=(-t)

	echo "${ARGS[@]}"
}

#####################################################################

REMOTE__QUERY_CONNECTION() {
	YQ -oy -r $@ "$REMOTE_CONNECTIONS_FILE" \
		| grep -v ^null$
}

REMOTE__QUERY_CONNECTION_WITH_FALLBACK() {
	while [[ $# -gt 0 ]] && [ ! $QUERY_RESULT ]
	do
		case $1 in
			.* ) QUERY_RESULT=$(REMOTE__QUERY_CONNECTION $1) ;;
			 * ) QUERY_RESULT="$1" ;;  # allows raw default value
		esac
		shift 1
	done

	echo $QUERY_RESULT
}
