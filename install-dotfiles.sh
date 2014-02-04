#!/bin/sh

cd ~
curl -fsSL https://raw.github.com/mad-p/dotfiles/master/install.sh | sed -e 's|git@github.com:|https://github.com/|' | sh
