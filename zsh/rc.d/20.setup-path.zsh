() {  # create path entries
	local PATH_ENTRY
	for PATH_ENTRY in \
		"$HOME/.local/bin" \
		"$(go env GOPATH 2>/dev/null)/bin" \
		"$HOME/.$(hostnamectl --static)" \
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
