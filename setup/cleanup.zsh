__yN 'keep logfile?' || {
	rm "$LOGFILE" \
		|| __ERROR "unable to remote '$LOGFILE'" \
		;
}

__SUCCESS
__SUCCESS '.wryn setup complete; have a nice day :)'
__SUCCESS

exit 0
