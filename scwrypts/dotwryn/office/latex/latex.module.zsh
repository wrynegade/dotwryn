#####################################################################

DEPENDENCIES+=(
	rg
	pdflatex
)

REQUIRED_ENV+=()

#####################################################################

${scwryptsmodule}.get-main-filename() {
	local FILENAME=$(SCWRYPTS__GET_REALPATH "$1")
	local DIRNAME="$FILENAME"

	for _ in {1..3}
	do
		CHECK_IS_MAIN_LATEX_FILE && return 0
		DIRNAME="$(dirname "$FILENAME")"
		echo.status "checking '$DIRNAME'"
		[[ $DIRNAME =~ ^$HOME$ ]] && break
		FILENAME=$(
			rg -l --max-depth 1 'documentclass' "$DIRNAME/" \
				| grep '\.tex$' \
				| head -n1 \
		)
		echo.status "here is '$FILENAME'"
	done

	echo.warning 'unable to find documentclass; pdflatex will probably fail'
	echo "$1"
}

${scwryptsmodule}.check-is-main-file() {
	[ ! $FILENAME ] && return 1
	grep -q 'documentclass' $FILENAME 2>/dev/null && echo $FILENAME || return 3
}

${scwryptsmodule}.get-pdf() {
	local FILENAME=$(dotwryn.office.latex.get-main-filename "$1" | sed 's/\.[^.]*$/.pdf/')
	[ $FILENAME ] && [ -f $FILENAME ] || utils.fail 1 "no compiled pdf found for '$1'; have you run 'build-pdf'?"
	echo.success 'found main pdf'
	echo $FILENAME
}
