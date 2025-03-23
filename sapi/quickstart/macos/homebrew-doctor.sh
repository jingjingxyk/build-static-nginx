#!/usr/bin/env bash

set -x

brew doctor

brew missing

exit 0

brew untap
brew untap  Homebrew/homebrew-cask-versions
brew untap  Homebrew/homebrew-services

brew cleanup
