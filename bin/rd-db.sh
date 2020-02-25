#!/bin/sh

#
# Not my script; big thanks to Sam Christensen (https://github.com/samachr)
#

#
# Requires one-time signin to onepassword:
# `op signin rent-dynamics.1password.com <your-email-address>`
#

ERROR_CODE=0;

OP_ERROR="I require op but it's not installed.    See https://1password.com/downloads/command-line/"
JQ_ERROR="I require jq but it's not installed."
FZF_ERROR="I require fzf but it's not installed.    See https://github.com/junegunn/fzf";
MSSQL_CLI_ERROR="I require mssql-cli but it's not installed.    See https://github.com/dbcli/mssql-cli/blob/master/doc/installation/macos.md#macos-installation";
PG_CLI_ERROR="I require pgcli but it's not installed.    See https://www.pgcli.com/install";

command -v op >/dev/null 2>&1        || { printf "%s\n\n" "$OP_ERROR"        >&2; ERROR_CODE=1; }
command -v jq >/dev/null 2>&1        || { printf "%s\n\n" "$JQ_ERROR"        >&2; ERROR_CODE=1; }
command -v fzf >/dev/null 2>&1       || { printf "%s\n\n" "$FZF_ERROR"       >&2; ERROR_CODE=1; }
command -v mssql-cli >/dev/null 2>&1 || { printf "%s\n\n" "$MSSQL_CLI_ERROR" >&2; ERROR_CODE=1; }
command -v pgcli >/dev/null 2>&1     || { printf "%s\n\n" "$PG_CLI_ERROR"    >&2; ERROR_CODE=1; }

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
