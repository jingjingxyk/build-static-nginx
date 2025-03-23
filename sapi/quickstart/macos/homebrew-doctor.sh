#!/usr/bin/env bash

set -x

brew doctor

brew missing

exit 0

brew list --formula --built-from-source
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1


brew untap
brew untap  Homebrew/homebrew-cask-versions
brew untap  Homebrew/homebrew-services

brew cleanup
