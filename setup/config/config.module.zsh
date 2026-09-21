#####################################################################

for setup_library in "${0:a:h}"/*.zsh
do
	case "${setup_library:t}" in
		( config.module.zsh ) ;;  # self
		( * ) source "${setup_library}" ;;
	esac
done
unset setup_library

#####################################################################

setup.config() { : \
	&& echo.status 'starting application configuration' \
	&& : \
	&& setup.config.generate-initial-local-config \
	&& setup.config.zsh \
	&& setup.config.vim \
	&& setup.scwrypts dotwryn system setup \
	&& setup.scwrypts generate i3 config \
	&& : \
	&& echo.success 'finished application configuration' \
	|| echo.error 'application configuration failed (see above)' \
; }
