#
# render / upload tools for MuseScore
#

# context wrapper for MuseScore CLI
use --group media mscore/cli
eval "${scwryptsmodule}() { ${scwryptsmodule}.cli \$@; }"

# render pdf from MuseScore file
use --group media mscore/render


# common parsers
use --group media mscore/zshparse
