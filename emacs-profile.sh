#!/run/current-system/profile/bin/bash

printf "** set up guix profile directory for emacs\n"
printf "*** Ensuring folder for emacs profile exists...\n"
mkdir -p "$HOME/.guix-extra-profiles"
mkdir -p "$HOME/.guix-extra-profiles/main-emacs"
export GUIX_EMACS_PROFILE="$HOME/.guix-extra-profiles/main-emacs/main-emacs"
printf "Profile will be installed at %s.\n" "$GUIX_EMACS_PROFILE"

printf "** use guix channel commits from =channel-specs.scm=\n"
printf "Reproducing branjam's guix channels for emacs-28...\n#+BEGIN_EXAMPLE\n"
mkdir -p emacs28install
guix pull --channels=channel-specs.scm --profile=./emacs28install/guix

printf "#+END_EXAMPLE\n** install emacs + doom dependencies into the =main-emacs= profile\n"
printf "Installing packages...\n#+BEGIN_EXAMPLE\n"
./emacs28install/guix/bin/guix package \
    -m dev-emacs-manifest.scm \
    -m main-emacs-manifest.scm \
    -m extra-emacs-manifest.scm \
    -m org-dependencies-manifest.scm \
    -p "$GUIX_EMACS_PROFILE"

printf "#+END_EXAMPLE\n** =bashrc= checks\n"
printf "+ ensure ~GUIX_EXTRA_PROFILES~ variable in =bashrc=\n"
printf "Ensuring proper shell environment...\n"
if ! grep -qF "GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" "$HOME/.bashrc"; then
    printf "GUIX_EXTRA_PROFILES=\"\$HOME\"/.guix-extra-profiles" >> "$HOME/.bashrc"
fi

printf "+ ensure direnv hook exists for activating project dependencies\n"
if ! grep -qF "eval \"\$(direnv hook bash)\"" "$HOME/.bashrc"; then
    printf "eval \"\$(direnv hook bash)\"" >> "$HOME/.bashrc"
fi

printf "+ activate =main-emacs= profile\n"
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
printf "** Finish guix setup\nDone! Shell now opens this emacs: %s\n" "$(which emacs)"

printf "** remove =emacs28install/guix= profile\n"
printf "Cleaning up...\n"
rm -rf emacs28install
