#!/run/current-system/profile/bin/bash

printf "** set up guix profile directory for emacs"
printf "Ensuring folder for emacs profile exists..."
mkdir -p "$HOME/.guix-extra-profiles"
mkdir -p "$HOME/.guix-extra-profiles/main-emacs"
export GUIX_EMACS_PROFILE="$HOME/.guix-extra-profiles/main-emacs/main-emacs"
printf "Profile will be installed at $GUIX_EMACS_PROFILE."

printf "** use guix channel commits from =channel-specs.scm="
printf "Reproducing branjam's guix channels for emacs-28..."
mkdir -p emacs28install
guix pull --channels=channel-specs.scm --profile ./emacs28install/guix

printf "** install emacs + doom dependencies into the =main-emacs= profile"
printf "Installing packages..."
./emacs28/guix/bin/guix package \
    -m dev-emacs-manifest.scm \
    -m main-emacs-manifest.scm \
    -m extra-emacs-manifest.scm \
    -m org-dependencies-manifest.scm \
    -p "$GUIX_EMACS_PROFILE"

printf "** =bashrc= checks"
printf "+ ensure ~GUIX_EXTRA_PROFILES~ variable in =bashrc="
printf "Ensuring proper shell environment..."
if ! grep -qF "GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" "$HOME/.bashrc"; then
    printf "GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" >> "$HOME/.bashrc"
fi

printf "+ ensure direnv hook exists for activating project dependencies"
if ! grep -qF "eval \"\$(direnv hook bash)\"" "$HOME/.bashrc"; then
    printf "eval \"\$(direnv hook bash)\"" >> "$HOME/.bashrc"
fi

printf "+ activate =main-emacs= profile"
if ! grep -qF \
    "GUIX_EMACS_PROFILE=\"\$HOME/.guix-extra-profiles/main-emacs/main-emacs\"" \
    "$HOME/.bashrc"; then
    printf "GUIX_EMACS_PROFILE=\"\$HOME/.guix-extra-profiles/main-emacs/main-emacs\"" \
        >> "$HOME/.bashrc"
fi

if ! grep -qF "source \"\$GUIX_EMACS_PROFILE\"/etc/profile" "$HOME/.bashrc"; then
    printf "source \"\$GUIX_EMACS_PROFILE\"/etc/profile" >> "$HOME/.bashrc"
fi

source "$GUIX_EMACS_PROFILE"/etc/profile
printf "** Finish guix setup\nDone! Shell now opens this emacs: %s" "$(which emacs)"

printf "** remove =emacs28install/guix= profile"
printf "Cleaning up..."
rm -rf emacs28install
