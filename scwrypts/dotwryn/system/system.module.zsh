#
# provides system setup utilities
#


# symlinks to source-controlled configurations
use system/symlinks --group dotwryn


# compile source-controlled terminfo files
use system/terminfo --group dotwryn


# common argument parsing
use system/zshparse --group dotwryn
