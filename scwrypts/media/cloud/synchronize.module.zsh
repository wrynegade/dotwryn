#####################################################################

REQUIRED_ENV+=(MEDIA_SYNC__TARGETS)

use cloud/synchronize-target --group media
use cloud/zshparse/actions --group media

#####################################################################

${scwryptsmodule}() {
	eval "$(USAGE.reset)"

	local \
		ACTION \
		PARSERS=(
			media.cloud.zshparse.actions
			)

	eval "$ZSHPARSEARGS"

	##########################################

	local TARGET_COUNT=${#MEDIA_SYNC__TARGETS[@]}
	local FAILED_COUNT=0

	echo.status "starting media ${ACTION}"

	local TARGET
	for TARGET in ${MEDIA_SYNC__TARGETS[@]}
	do
		media.cloud.synchronize-target \
			--action "${ACTION}" \
			--target "${TARGET}" \
				|| ((FAILED_COUNT+=1))
	done

	[[ $FAILED_COUNT -eq 0 ]] \
		&& echo.success "successfully completed ${ACTION} for ${TARGET_COUNT} / ${TARGET_COUNT} target(s)" \
		||   ERROR "failed ${ACTION} for ${FAILED_COUNT} / ${TARGET_COUNT} target(s)" \
		;
}

#####################################################################
