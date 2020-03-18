#!/bin/sh

#
# Not my script; big thanks to Sam Christensen (https://github.com/samachr)
#

#
# Requires one-time signin to onepassword:
# `op signin rent-dynamics.1password.com <your-email-address>`
#

ERROR_CODE=0;

LINK_OP="https://1password.com/downloads/command-line"
LINK_JQ="https://github.com/stedolan/jq"
LINK_FZF="https://github.com/junegunn/fzf";
LINK_MSSQLCLI="https://github.com/dbcli/mssql-cli";
LINK_PGCLI="https://www.pgcli.com/install";

REQUIREMENT_ERROR="I require %s but it's not installed. (%s)";

command -v op >/dev/null 2>&1\
	|| { printf "$REQUIREMENT_ERROR\n\n" 'op' "$LINK_OP" >&2; ERROR_CODE=1; }
command -v jq >/dev/null 2>&1\
	|| { printf "$REQUIREMENT_ERROR\n\n" 'jq' "$LINK_JQ" >&2; ERROR_CODE=1; }
command -v fzf >/dev/null 2>&1\
	|| { printf "$REQUIREMENT_ERROR\n\n" 'fzf' "$LINK_FZF" >&2; ERROR_CODE=1; }
command -v mssql-cli >/dev/null 2>&1\
	|| { printf "$REQUIREMENT_ERROR\n\n" 'mssql-cli' "$LINK_MSSQLCLI" >&2; ERROR_CODE=1; }
command -v pgcli >/dev/null 2>&1\
	|| { printf "$REQUIREMENT_ERROR\n\n" 'pgcli' "$LINK_PGCLI" >&2; ERROR_CODE=1; }


[[ $ERROR_CODE -ne 0 ]] && exit $ERROR_CODE;

echo "getting 1pass session"
if [ -z "$OP_SESSION_rent_dynamics" ]; then
    eval $(op signin rent_dynamics)
else 
    if ! op list templates > /dev/null; then
        eval $(op signin rent_dynamics)
    fi
fi

echo "getting options..."
credentials=$(op get item "$(op list items | jq '.[] | select(.templateUuid == "102") | .overview.title' | sed 's/\"//g' | sort | fzf --height=20% --layout=reverse)" |jq '.details.sections[0].fields[] | {(.t) : .v }' | jq -s 'add | (.type, if .url then .url else .server end, .username, .password, .database)')
database_type=$(echo $credentials | awk '{print $1;}' | xargs)
server=$(echo $credentials | awk '{print $2;}' | xargs)
user=$(echo $credentials | awk '{print $3;}' | xargs)
pass=$(echo $credentials | awk '{print $4;}' | xargs)

if [ $database_type == "mssql" ]; then
    echo "microsoft sql database detected, connecting with mssql-cli"
    mssql-cli -S $server -U $user -P $pass
elif [ $database_type == "postgresql" ]; then
    echo "postgres database detected, connecting with pgcli"
    dbname=$(echo $credentials | awk '{print $5;}' | xargs)
    PGPASSWORD=$pass pgcli -h $server -U $user -d $dbname
else
    database_type=$(echo -e "mssql\npostgresql" | fzf --height=20% --layout=reverse)
    if [ $database_type == "mssql" ]; then
        echo "microsoft sql database chosen, connecting with mssql-cli"
        mssql-cli -S $server -U $user -P $pass
    elif [ $database_type == "postgresql" ]; then
        echo "postgres database chosen, connecting with pgcli"
        dbname=$(echo $credentials | awk '{print $5;}' | xargs)
        PGPASSWORD=$pass pgcli -h $server -U $user -d $dbname
    fi
fi
