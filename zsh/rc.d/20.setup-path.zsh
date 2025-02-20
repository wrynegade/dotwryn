() {  # create path entries
	local PATH_ENTRY
	for PATH_ENTRY in \
		"${GOPATH}/bin" \
		"${HOME}/.local/bin" \
		"${DOTWRYN}/config/bin" \
		"${DOTWRYN}/config/local/$(hostnamectl --static)/bin" \
		;
	do
		echo "$PATH" | sed 's/:/\n/g' | grep -q "^$PATH_ENTRY$" \
			&& continue  # avoid duplicate PATH entries

		mkdir -p "$PATH_ENTRY" 2>/dev/null \
			|| continue  # avoid invalid PATH entries

		export PATH="$PATH_ENTRY:$PATH"
	done

	return 0
}
