#####################################################################

DEPENDENCIES+=()
REQUIRED_ENV+=()

#####################################################################

PARSE_CONNECTION() {
	[ ! $CONNECTION ] && [ ! $REMOTE_NAME ] && {
		ERROR 'cannot parse connection without specifying CONNECTION or REMOTE_NAME'
		return 1
	}

	[ $REMOTE_NAME ] && CONNECTION=$(GET_CONNECTION $REMOTE_NAME)

	[ ! $CONNECTION ] && {
		ERROR "no such connection with name '$REMOTE_NAME'"
	}

	local CONNECTION_DETAILS=$(echo $CONNECTION | sed 's/|/ /g;')

	REMOTE_ID=$(echo $CONNECTION_DETAILS | awk '{print $1;}')
	REMOTE_NAME=$(echo $CONNECTION_DETAILS | awk '{print $2;}')
	REMOTE_HOST=$(echo $CONNECTION_DETAILS | awk '{print $3;}')
	REMOTE_ARGS+=($(echo $CONNECTION_DETAILS | awk '{$1=$2=$3="";}1'))
}

GET_CONNECTIONS() {
	(
		echo '0 | localhost | localhost'
		echo "0 | $(hostnamectl --static) | localhost"
		sed -n 's/#.*//;s/ \+$//;/./p' "$REMOTE_CONNECTIONS_FILE"
	) | sort -u
}

GET_CONNECTION() {
	[ ! $1 ] && return 1
	GET_CONNECTIONS | grep "^[0-9]\+ *| *$1 *|" | head -n1
}

GET_CONNECTION_NAMES() {
	echo ($(GET_CONNECTIONS | awk '{print $1;}'))
}

IS_VALID_CONNECTION_NAME() {
	GET_CONNECTION $1 | grep -q '|'
}
