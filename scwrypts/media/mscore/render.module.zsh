#####################################################################

use --group media mscore/cli
use --group media mscore/zshparse/filename

#####################################################################


${scwryptsmodule}.pdf() {
	eval "$(USAGE.reset)"

	local \
		MSCORE_FILENAME \
		PARSERS=(
			media.mscore.zshparse.filename
			)

	eval "$ZSHPARSEARGS"

	##########################################


}
