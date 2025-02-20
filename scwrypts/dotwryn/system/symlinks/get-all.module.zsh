${scwryptsmodule}() {
	() {  # DYNAMIC_CONFIGS
		##########################################

		local ETC_CONFIGS
		for ETC_CONFIGS in \
			"${DOTWRYN}/config/etc" \
			"${DOTWRYN}/config/local/${DOTWRYN_HOSTNAME}/etc" \
			;  # $HOST/etc will overwrite etc
		do
			find "${ETC_CONFIGS}" -mindepth 1 -type f 2>/dev/null \
				| sed "s|\(${ETC_CONFIGS}/\(.*\)\)|\\1^/etc/\\2|"
		done

		##########################################

		local USER_CONFIGS
		for USER_CONFIGS in \
			"${DOTWRYN}/config/user" \
			"${DOTWRYN}/config/local/${DOTWRYN_HOSTNAME}/user" \
			; # $HOST/user will overwrite user
		do
			echo.debug "$(find "${USER_CONFIGS}" -mindepth 1 -type f 2>/dev/null \
					| sed "s|\(${USER_CONFIGS}/\(.*\)\)|\\1^${XDG_CONFIG_HOME}/\\2|"
				)"
			find "${USER_CONFIGS}" -mindepth 1 -type f 2>/dev/null \
				| sed "s|\(${USER_CONFIGS}/\(.*\)\)|\\1^${XDG_CONFIG_HOME}/\\2|"
				;
		done

		##########################################

		local SCWRYPTS_GROUP_ENVS=(
			scwrypts
			$(find "$(scwrypts.config.group scwrypts root)/plugins" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
			$(find "${DOTWRYN}/scwrypts" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
		)

		local GROUP_MATCH_REGEX="\\($(printf '\|%s' ${SCWRYPTS_GROUP_ENVS[@]} | sed 's/^\\|//')\\)"
		local LOCAL_MATCH_REGEX='\(\.'${DOTWRYN_HOSTNAME}'\(\..*\+\)*\)\?'
	
		local LOCAL_DIR="${SCWRYPTS_CONFIG_PATH}/environments"
		local SOURCE_DIR="${DOTWRYN}/config/scwrypts/environments"
	
		find "${DOTWRYN}/config/scwrypts/environments" -mindepth 1 -maxdepth 1 -name \*.env.yaml \
			| sed -n "s^.*/\(local${LOCAL_MATCH_REGEX}\.${GROUP_MATCH_REGEX}.env.yaml\)$${SOURCE_DIR}/\1^${LOCAL_DIR}/\1^p" \
			| grep -v '\.secret\.' \
			;
	} | column -ts '^'

	#  STATIC CONFIGS
	#   ---------------------------------------------- | -------------------------------------------------
	#   fully qualified source path                    | fully qualified target path
	#   ---------------------------------------------- | -------------------------------------------------
	echo "
		${DOTWRYN}/config/scwrypts/config.zsh            ${XDG_CONFIG_HOME}/scwrypts/config.zsh
	"

}
