#!/run/current-system/profile/bin/bash

mkdir $HOME/.guix-extra-profiles
mkdir $HOME/.guix-extra-profiles/main-emacs
guix package \
    -m dev-emacs-manifest.scm \
    -m main-emacs-manifest.scm \
    -m extra-emacs-manifest.scm \
    -m org-dependencies-manifest.scm \
    -p $HOME/.guix-extra-profiles/main-emacs/main-emacs
