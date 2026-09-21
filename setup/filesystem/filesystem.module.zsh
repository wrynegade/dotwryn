#####################################################################

for setup_library in "${0:a:h}"/*.zsh
do
	case "${setup_library:t}" in
		( filesystem.module.zsh ) ;;  # self
		( * ) source "${setup_library}" ;;
	esac
done
unset setup_library

#####################################################################

setup.filesystem() { : \
	&& setup.filesystem.ensure-paths \
	&& setup.filesystem.git \
; }
