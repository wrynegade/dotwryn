#
# configures user-space symlinks and settings
#


# get a two-column output of all source-controlled symlinks
use system/symlinks/get-all --group dotwryn


# actually configure the target symlinks listed from the above function
use system/symlinks/setup --group dotwryn
