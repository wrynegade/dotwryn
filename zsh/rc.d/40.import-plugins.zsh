() {
	local PLUGIN

	for PLUGIN in ${ZSH_PLUGINS[@]}
	do
		[ -f "$PLUGIN" ] && source "$PLUGIN"
	done

	return 0
}
