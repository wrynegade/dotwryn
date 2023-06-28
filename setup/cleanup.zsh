yN 'keep logfile?' || {
	rm "$LOGFILE" \
		|| ERROR "unable to remote '$LOGFILE'" \
		;
}

SUCCESS '
	.wryn setup complete; have a nice day :)
	'

exit 0
