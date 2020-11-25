#!/run/current-system/profile/bin/bash

# set up guix profile directory for emacs (use -p for idempotency)
mkdir -p "$HOME/.guix-extra-profiles"
mkdir -p "$HOME/.guix-extra-profiles/main-emacs"
export GUIX_EMACS_PROFILE="$HOME/.guix-extra-profiles/main-emacs/main-emacs"

# install emacs + doom dependencies into the "main-emacs" profile
guix package \
    -m dev-emacs-manifest.scm \
    -m main-emacs-manifest.scm \
    -m extra-emacs-manifest.scm \
    -m org-dependencies-manifest.scm \
    -p "$GUIX_EMACS_PROFILE"

# ensure GUIX_EXTRA_PROFILES variable in bashrc
if ! grep -qF "export GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" "$HOME/.bashrc"; then
    echo "export GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" >> "$HOME/.bashrc"
fi

# ensure direnv hook exists for activating project dependencies
if ! grep -qF "eval \"\$(direnv hook bash)\"" "$HOME/.bashrc"; then
    echo "eval \"\$(direnv hook bash)\"" >> "$HOME/.bashrc"
fi

# activate "main-emacs" profile
. "$GUIX_EMACS_PROFILE"/etc/profile
