find "${HOME}/.1password/agent.sock" &>/dev/null \
	&& export SSH_AUTH_SOCK="${HOME}/.1password/agent.sock"

return 0
