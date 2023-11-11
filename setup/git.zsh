#####################################################################

SETUP__GIT() {
	STATUS 'updating remotes for .wryn'
	cd $DOTWRYN_PATH
	git remote add upstream git@github.com:wrynegade/dotwryn.git
	git remote set-url --add --push upstream git@github.com:wrynegade/dotwryn.git
	git remote set-url --add --push upstream git@yage.io:wrynegade/dotwryn.git
	git remote set-url --add --push upstream git@bitbucket.org:wrynegade/dotwryn.git

	STATUS 'updating upstream for zsh/plugins/code-activator'
	cd $DOTWRYN_PATH/zsh/plugins/code-activator
	git remote rm upstream 2>/dev/null
	git remote add upstream git@yage.io:zsh/code-activator.git
	git remote set-url --add --push upstream git@yage.io:zsh/code-activator.git
	git remote set-url --add --push upstream git@github.com:wrynegade/code-activator-zsh.git

	STATUS 'updating upstream for zsh/plugins/scwrypts'
	cd $DOTWRYN_PATH/zsh/plugins/scwrypts
	git remote rm upstream 2>/dev/null
	git remote add upstream git@yage.io:zsh/code-activator
	git remote set-url --add --push upstream git@yage.io:zsh/code-activator
	git remote set-url --add --push upstream git@github.com:wrynegade/scwrypts.git

	cd $DOTWRYN_PATH
}
