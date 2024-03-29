;; Light-weight solution for dir-local commands, for when you don't want
;; bring in a tool such as Make or NPM.

;; 1. In your init file, define a global placeholder variable that
;; will hold the per-directory recipe, and a global recipe function
;; that will call the local recipe when defined:

;; (defvar run-command-recipe-dir-locals-fn nil)

;; (defun run-command-recipe-dir-locals ()
;;   (when run-command-recipe-dir-locals-fn
;;     (funcall run-command-recipe-dir-locals-fn)))

;; 2. Type `M-x run-command-recipes RET' and add
;; `run-command-recipe-dir-locals' to the listn.

;; 3. In the directory where you want some commands activated, create
;; a `.dir-locals.el' file and add definitions such as (note the
;; leading periods):

((nil . ((run-command-recipe-dir-locals-fn
          . (lambda ()
              (list
               (list :command-name "guix package emacs"
                     :command-line "guix package -L ~/guix-extra-channels \
-m dev-emacs-manifest.scm \
-m extra-emacs-manifest.scm \
-m main-emacs-manifest.scm \
-m org-dependencies-manifest.scm \
-p ~/.guix-extra-profiles/emacs/emacs")))))))

;; More about per-directory local variables:
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html
