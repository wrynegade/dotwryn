#####################################################################

REQUIRED_ENV+=(MEDIA_SYNC__S3_BUCKET)

use cloud/aws
use cloud/zshparse/actions --group media

#####################################################################

${scwryptsmodule}() {
	local \
		TARGET TARGET_CLOUD TARGET_LOCAL \
		ACTION \
		PARSERS=(
			media.cloud.zshparse.actions
			)

	eval "$ZSHPARSEARGS"

	##########################################

	local A B
	case $ACTION in
		( push ) A="$TARGET_LOCAL"; B="$TARGET_CLOUD" ;;
		( pull ) A="$TARGET_CLOUD"; B="$TARGET_LOCAL" ;;

		( pull-first-synchronize )
			: \
				&& media.cloud.synchronize-target \
					--target "${TARGET}" \
					--action pull \
				&& media.cloud.synchronize-target \
					--target "${TARGET}" \
					--action push \
				&& return 0 \
				|| return 1 \
				;
			;;

		( push-first-synchronize )
			: \
				&& media.cloud.synchronize-target \
					--target "${TARGET}" \
					--action push \
				&& media.cloud.synchronize-target \
					--target "${TARGET}" \
					--action pull \
				&& return 0 \
				|| return 1 \
				;
			;;
	esac

	echo.status "${ACTION}ing ${TARGET}"
	cloud.aws s3 sync $A $B \
		&& echo.success "${TARGET} up-to-date" \
		|| { ERROR "unable to sync ${TARGET} (see above)"; return 1; }
}

#####################################################################

${scwryptsmodule}.parse() {
	# local TARGET TARGET_CLOUD TARGET_LOCAL
	local PARSED=0

	case $1 in
		( --target )
			PARSED=2
			TARGET="$2"
			;;
	esac

	return $PARSED
}

${scwryptsmodule}.parse.usage() {
	USAGE__options+="
		--target <string>   local/remote target to synchronize
	"
}

${scwryptsmodule}.parse.validate() {
	[ "${TARGET}" ] \
		|| ERROR 'must specify a target'

	TARGET_LOCAL="${HOME}/${TARGET}"
	TARGET_CLOUD="s3://${MEDIA_SYNC__S3_BUCKET}/${TARGET}"
}
