#####################################################################

DEPENDENCIES+=(
	notify-send
)
REQUIRED_ENV+=()

#####################################################################

NOTIFY_SEND() { notify-send "$SCWRYPT_GROUP : $SCWRYPT_NAME" "$1"; }

_NOTIFY() {
	NOTIFY_SEND "$1 : ${*:2}"
	$1 ${@:2}
}

NOTIFY_SUCCESS() { _NOTIFY SUCCESS $@; }
NOTIFY_ERROR()   { _NOTIFY ERROR   $@; }
NOTIFY_FAIL()    { _NOTIFY FAIL    $@; }
