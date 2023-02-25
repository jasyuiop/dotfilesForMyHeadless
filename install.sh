#!/bin/bash
git clone --bare git@github.com:jasyuiop/dotfilesForMyHeadless.git $HOME/.cfg
function dotfiles {
	/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
dotfiles checkout
if [ $? = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
dotfiles checkout
dotfiles config status.showUntrackedFiles no
