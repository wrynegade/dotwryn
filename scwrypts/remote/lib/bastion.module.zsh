GET_PASSTHROUGH_PREFIX() {
	echo "source ~/.zshrc &>/dev/null; SUBSCWRYPT=$((SUBSCWRYPT+1)) SCWRYPTS_LOG_LEVEL=$SCWRYPTS_LOG_LEVEL scwrypts"
}
