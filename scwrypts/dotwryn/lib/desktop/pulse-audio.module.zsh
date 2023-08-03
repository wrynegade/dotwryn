#####################################################################

DEPENDENCIES+=(
	pactl
	yq
)
REQUIRED_ENV+=()

#####################################################################

PA__SET_DEFAULT_AUDIO() {
	local USAGE="
		usage: CARD_PATTERN [...options...]

		options
		  -p, --profile   change profile of card (requires -i)
		  -i, --id        when changing profile (-p), the id of the card to change

		  --hdmi-wait     wait for the hdmi card to be available before changing default
	"
	local CARD_PATTERN=()
	local CARD_PROFILE CARD_ID

	local HDMI_WAIT=0

	while [[ $# -gt 0 ]]
	do
		case $1 in
			--hdmi-wait ) HDMI_WAIT=1 ;;

			--profile ) CARD_PROFILE="$2"; shift 1 ;;
			--id      ) CARD_ID="$2";      shift 1 ;;

			* ) CARD_PATTERN+=($1) ;;
		esac
		shift 1
	done

	##########################################

	[[ ${#CARD_PATTERN[@]} -gt 0 ]] || ERROR "no card pattern specified"

	CHECK_ERRORS -n || return 1

	##########################################

	[[ $CARD_PATTERN =~ hdmi ]] && HDMI_WAIT=1

	[[ $HDMI_WAIT -eq 1 ]] \
		&& STATUS 'waiting for hdmi sink to be available...' \
		&& until echo $(pactl list sinks 2>/dev/null | grep  'Name.*hdmi'); do sleep 1; done \
		&& SUCCESS 'hdmi sink ready!' \
		;

	[ $CARD_ID ] && [ $CARD_PROFILE ] \
		&& STATUS "setting profile $CARD_PROFILE for card#$CARD_ID" \
		&& pactl set-card-profile $CARD_ID $CARD_PROFILE \
		&& SUCCESS "profile set" \
		;

	STATUS "setting default audio sink to '$CARD_PATTERN'"
	pactl set-default-sink $(pactl list sinks 2>/dev/null | grep "Name.*$CARD_PATTERN" | sed 's/^\s*//' | yq -r .Name) \
		&& SUCCESS "default sink set to '$CARD_PATTERN'" \
		|| { ERROR "unable to set sink to '$CARD_PATTERN'" ; return 1; }
}
