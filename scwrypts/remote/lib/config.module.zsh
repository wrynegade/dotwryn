#####################################################################

DEPENDENCIES+=(yq)

#####################################################################

${scwryptsmodule}.get-connection-string() {
	local REMOTE_NAME="$1"
	[ $(remote.config.query-connection .sessions.$REMOTE_NAME.host) ] \
		|| echo.error "no such connection $REMOTE_NAME exists" \
		|| return 1

	local CONNECTION_HOST=$(remote.config.query-connection .sessions.$REMOTE_NAME.host)
	[ $CONNECTION_HOST ] \
		|| echo.error "connection $REMOTE_NAME is misconfigured; missing 'host' field" \
		|| return 1

	local CONNECTION_USER=$(remote.config.query-connection .sessions.$REMOTE_NAME.user)
	[ $CONNECTION_USER ] || CONNECTION_USER=$(remote.config.query-connection .default.user)

	[ $CONNECTION_USER ] \
		&& CONNECTION_STRING="${CONNECTION_USER}@${CONNECTION_HOST}" \
		|| CONNECTION_STRING="$CONNECTION_HOST" \
		;

	echo $CONNECTION_STRING
}

${scwryptsmodule}.get-ssh-args() {
	local REMOTE_NAME
	local TYPE=ssh
	local USE_TTY=true

	while [[ $# -gt 0 ]]
	do
		case $1 in
			( -t | --type ) TYPE=$2;    shift 1 ;;
			( --use-tty   ) USE_TTY=$2; shift 1 ;;

			( --no-tty ) USE_TTY=false ;;

			( * )
				[ $REMOTE_NAME ] && { echo.error "too many args :c"; return 1; }
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

	local PORT=$(remote.config.query-connection .sessions.$REMOTE_NAME.port)

	[ $PORT ] && {
		case $TYPE in
			( ssh | xserver | tmux ) ARGS+=(-p $PORT) ;;
			( scp ) ARGS+=(-P $PORT) ;; # not really in use, just a sample
			( * )
				WARNING "
					port is specified, but I'm not sure whether to use '-p' or '-P'

					if this command fails, try adding your --type to the appropriate
					list in '$(scwrypts.config.group remote root)/lib/config.module.zsh'
				 "
				ARGS+=(-p $PORT)
				;;
		esac
	}

	ARGS+=($(remote.config.query-connection .session.$REMOTE_NAME.$TYPE.args))

	[[ $USE_TTY =~ true ]] && ARGS+=(-t)

	echo "${ARGS[@]}"
}

#####################################################################

${scwryptsmodule}.query-connection() {
	utils.yq -oy -r $@ "$REMOTE_CONNECTIONS_FILE" \
		| grep -v ^null$
}

${scwryptsmodule}.query-connection-with-fallback() {
	while [[ $# -gt 0 ]] && [ ! $QUERY_RESULT ]
	do
		case $1 in
			( .* ) QUERY_RESULT=$(remote.config.query-connection $1) ;;
			(  * ) QUERY_RESULT="$1" ;;  # allows raw default value
		esac
		shift 1
	done

	echo $QUERY_RESULT
}
