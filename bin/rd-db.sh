#!/bin/sh

#
# Not my script originally; big thanks to Sam Christensen (https://github.com/samachr)
#

#
# Requires one-time signin to onepassword:
# `op signin rent-dynamics.1password.com <your-email-address>`
#

FZF_HEIGHT=20;
OP_DB_TEMPLATE_UUID=102;


REQUIREMENT_ERROR="I require %s but it's not installed. (%s)\n\n";
REQUIREMENT_ERROR_CODE=1;

LINK_OP="https://1password.com/downloads/command-line";
LINK_JQ="https://github.com/stedolan/jq";
LINK_FZF="https://github.com/junegunn/fzf";
LINK_MSSQLCLI="https://github.com/dbcli/mssql-cli";
LINK_PGCLI="https://www.pgcli.com/install";

OP_ERROR='\n\n1-password error. Double check password and op-cli configuration\n
Have you run the one-time signin? (`op signin rent-dynamics.1password.com <your-email-address>`)\n\n';
OP_ERROR_CODE=2;

DB_SELECT_ERROR='No valid database selected. Exiting.\n\n';
DB_SELECT_ERROR_CODE=3;

DB_USER_WARNING='WARNING:No username available for selected connection: (%s)\n\n';
DB_USER_ERROR='No username supplied. Exiting.\n';
DB_USER_ERROR_CODE=4;

DB_PASSWORD_WARNING='WARNING : No password available for selected connection.\n';

DB_TYPE_DETECTED='Database type detected! (%s) Connecting...\n';
DB_TYPE_SELECTED='Database type selected. (%s) Connecting...\n';


ERROR_CODE=0;

command -v op >/dev/null 2>&1\
	|| { ERROR_CODE="$REQUIREMENT_ERROR_CODE"; printf "$REQUIREMENT_ERROR" 'op' "$LINK_OP" >&2; };
command -v jq >/dev/null 2>&1\
	|| { ERROR_CODE="$REQUIREMENT_ERROR_CODE"; printf "$REQUIREMENT_ERROR" 'jq' "$LINK_JQ" >&2; };
command -v fzf >/dev/null 2>&1\
	|| { ERROR_CODE="$REQUIREMENT_ERROR_CODE"; printf "$REQUIREMENT_ERROR" 'fzf' "$LINK_FZF" >&2; };
command -v mssql-cli >/dev/null 2>&1\
	|| { ERROR_CODE="$REQUIREMENT_ERROR_CODE"; printf "$REQUIREMENT_ERROR" 'mssql-cli' "$LINK_MSSQLCLI" >&2; };
command -v pgcli >/dev/null 2>&1\
	|| { ERROR_CODE="$REQUIREMENT_ERROR_CODE"; printf "$REQUIREMENT_ERROR" 'pgcli' "$LINK_PGCLI" >&2; };

[[ "$ERROR_CODE" -ne 0 ]] && exit "$ERROR_CODE";


op list templates >/dev/null 2>&1 || {
	unset OP_SESSION_rent_dynamics;
	eval $(op signin rent_dynamics 2>/dev/null);

	op list templates >/dev/null 2>&1 || { printf "$OP_ERROR" >&2; exit "$OP_ERROR_CODE"; };
}


printf "\nSelect database connection:";
connection=$(\
	op list items 2>/dev/null \
		| jq '.[] | select(.templateUuid == "'$OP_DB_TEMPLATE_UUID'") | .overview.title' \
		| sed 's/\"//g' \
		| sort \
		| fzf --height="$FZF_HEIGHT"% --layout=reverse \
);

[[ ! "$connection" || "$connection" == 'null' ]] && { printf "$DB_SELECT_ERROR" >&2; exit "$DB_SELECT_ERROR_CODE"; };

credentials=$(\
	op get item "$connection" 2>/dev/null \
		| jq '.details.sections[0].fields[] | {(.t) : .v }' \
		| jq -s 'add | (.type, if .url then .url else .server end, .username, .password, .database)' \
);

database_type=$(echo $credentials | awk '{print $1;}' | xargs);
server=$(echo $credentials | awk '{print $2;}' | xargs);
user=$(echo $credentials | awk '{print $3;}' | xargs);
pass=$(echo $credentials | awk '{print $4;}' | xargs);
dbname=$(echo $credentials | awk '{print $5;}' | xargs);

[[ ! "$user" || "$user" == 'null' ]] && {
	printf "$DB_USER_WARNING" "$(echo $connection | sed 's/^\s+\(.*\)\s+$/\1/')";
	printf "Enter username:";
	read user;

	[ ! "$user" ] && { printf "$DB_USER_ERROR" >&2; exit "$DB_USER_ERROR_CODE"; };
};

[[ ! "$pass" || "$pass" == 'null' ]] && {
	printf "$DB_PASSWORD_WARNING";
	printf "Enter password (%s::%s):" "$(echo $connection | sed 's/^\s+\(.*\)\s+$/\1/')" "$user";
	read pass;
};

if [ "$database_type" == "mssql" ]; then
	printf "$DB_TYPE_DETECTED" "Microsoft SQL";
	mssql-cli -S "$server" -U "$user" -P "$pass";
elif [ "$database_type" == "postgresql" ]; then
	printf "$DB_TYPE_DETECTED" "Postgres";
	PGPASSWORD="$pass" pgcli -h "$server" -U "$user" -d "$dbname";
else
	database_type=$(echo -e "mssql\npostgresql" | fzf --height="$FZF_HEIGHT"% --layout=reverse);
	if [ "$database_type" == "mssql" ]; then
		printf "DB_TYPE_SELECTED" "Microsoft SQL";
		mssql-cli -S "$server" -U "$user" -P "$pass";
	elif [ "$database_type" == "postgresql" ]; then
		printf "DB_TYPE_SELECTED" "Postgres";
		PGPASSWORD="$pass" pgcli -h "$server" -U "$user" -d "$dbname";
	fi
fi
