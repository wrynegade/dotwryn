#!/bin/sh
# Default shell environment
LOCAL_OVERRIDES="$HOME/.config/wryn/env.sh"
[ -f "$LOCAL_OVERRIDES" ] \
	&& source "$LOCAL_OVERRIDES" \
	|| {
		touch $LOCAL_OVERRIDES \
			&& echo '#!/bin/sh' > $LOCAL_OVERRIDES \
			&& echo '# Local overrides of .wryn environment variables '>> $LOCAL_OVERRIDES
		}
