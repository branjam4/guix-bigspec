;; -*- lexical-binding: t -*-

(setq custom-file "~/src/guix/custom.el")
(load custom-file)


;; (speedbar)
(vertico-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(context-menu-mode)
(scroll-bar-mode -1)
(global-text-scale-adjust -3)
(direnv-mode 1)
(allout-mode)
(ednc-mode)

;; (objed-mode)
;; (fido-mode 1)
(toggle-frame-fullscreen)
;; (require 'minibuffer-header) (minibuffer-header-mode)
(require 'hierarchy)
;; (load-theme 'adwaita)
;; (load-theme 'manoj-dark)
;; (load-theme 'tango)
;; (load-theme 'wombat)
;; (load-theme 'whiteboard)
;; (load-theme 'nano-dark)
;; (mood-line-mode)
(nano-modeline-mode 1)
;; (doom-modeline-mode 1)

(global-set-key [67108910] 'embark-act)
(global-set-key "k" 'ibuffer)
(global-set-key "" 'ace-window)
(global-set-key (kbd "M-g C-c") 'compile)
(setq prefix-help-command #'embark-prefix-help-command)
;; (require 'orderless)
;; (require 'corfu)
(require 'avy)
(require 'ace-window)
(require 'transient)
(require 'webjump)

(global-set-key (kbd "M-g C-z") 'webjump)
(setq webjump-sites
      (append '(
                ("Git Internals Tutorial" . "www.leshenko.net/p/ugit")
                ("GitHub" . [simple-query "www.github.com" "www.github.com/" ""])
                )
              webjump-sample-sites))

 (require 'elfeed-tube)
 (elfeed-tube-setup)
 (define-key elfeed-show-mode-map (kbd "F") 'elfeed-tube-fetch)
 (define-key elfeed-show-mode-map [remap save-buffer] 'elfeed-tube-save)
 (define-key elfeed-search-mode-map (kbd "F") 'elfeed-tube-fetch)
 (define-key elfeed-search-mode-map [remap save-buffer] 'elfeed-tube-save)

(require 'elfeed-tube-mpv)
(define-key elfeed-show-mode-map (kbd "C-c C-f") 'elfeed-tube-mpv-follow-mode)
(define-key elfeed-show-mode-map (kbd "C-c C-w") 'elfeed-tube-mpv-where)

(transient-define-prefix symbol-overlay-transient ()
  "Symbol Overlay transient."
  ["Symbol Overlay"
   ["Overlays"
    ("." "Add/Remove at point" symbol-overlay-put)
    ("k" "Remove All" symbol-overlay-remove-all)
    ]
   ["Move to Symbol"
    ("n" "Next" symbol-overlay-switch-forward)
    ("p" "Previous" symbol-overlay-switch-backward)
    ]
   ["Other"
    ("m" "Highlight symbol-at-point" symbol-overlay-mode)
    ]
   ]
  )

(transient-define-prefix completions-transient ()
  "Completions transient."
  ["Completion"
   ["Navigation Completion"
    ("i" "Consult Imenu" consult-imenu)
    ("f" "Navigate to file or URL" ffap-menu)
    ]
   ["Emacs command completion"
    ("k" "Commands for keymap" embark-bindings-in-keymap)
    ("b" "Top-level keybindings" embark-bindings)
    ("m" "Local mode commands" consult-mode-command)
    ("n" "Activate minor mode" consult-minor-mode-menu)
    ]
   ["Find multi"
    ("I" "Consult Imenu (multi)" bran/consult-imenu-multi)
    ]
   ]
  )

(defun bran/consult-imenu-multi (&optional query)
  "Select item from the imenus of all buffers from the same project."
  (interactive "P")
  (unless (keywordp (car-safe query))
    (setq query (list :sort 'alpha
                      :directory (and (not query) 'project))))
  (let ((buffers (consult--buffer-query-prompt "Go to item" query)))
    (consult-imenu--select (car buffers)
                           (consult-imenu--multi-items (cdr buffers)))))

(define-skeleton skeleton-skel
  "Interactive skeleton for writing skeletons."
  > "(define-skeleton " (skeleton-read "Skeleton name: ") \n
  > "\"" (skeleton-read "Docstring: ") "\""
  > ("Content line: " \n str) _ ")")

(define-skeleton easy-menu-skeleton
  "Test of easy menu functionality."
  "Enter menu name: "
  "(easy-menu-define " str "-menu global-map" \n
  "\"" ("Documentation for menu: " str) "\"" \n
  "'(" str \n
  > ("Enter menu item: " "[\"" str "\" " ("Enter function: " str) "]" \n) "))")

(easy-menu-define completions-menu global-map
  "Menu for completion convenience commands."
  '("Completion"
    ["Navigation" completions-transient]
    "---"
    ("Guix Command Shortcuts"
     "---"
     ["Search Packages" bran/guix-search-transient]
     "---"
     ["Home Reconfigure" bran/guix-home-reconfigure])))

(global-set-key (kbd "M-s C-M-p") #'bran/guix-search-transient)

(defun bran/guix-home-reconfigure (arg)
  "Run 'guix home reconfigure' on my home configuration file."
  (interactive "p")
  (detached-shell-command (concat "guix home reconfigure " (expand-file-name "~/src/guix/home-configuration.scm")) arg))

(use-package tempel
  :init
  (defun tempel-setup-capf ()
      ;; Add the Tempel Capf to `completion-at-point-functions'.
      ;; `tempel-expand' only triggers on exact matches. Alternatively use
      ;; `tempel-complete' if you want to see all matches, but then you
      ;; should also configure `tempel-trigger-prefix', such that Tempel
      ;; does not trigger too often when you don't expect it. NOTE: We add
      ;; `tempel-expand' *before* the main programming mode Capf, such
      ;; that it will be tried first.
      (setq-local completion-at-point-functions
                  (cons #'tempel-expand
                        completion-at-point-functions))))

(with-eval-after-load 'mhtml-mode
  (easy-menu-define url-handler-menu mhtml-mode-map
    "Menu for rendering a url visited by url-handler-mode."
    '("Browse"
      ["Navigate to file or URL" ffap-menu]
      ["View Buffer as html page" shr-render-buffer])))

;; (use-package orderless
;;        :init
;;        ;; Configure a custom style dispatcher (see the Consult wiki)
;;        ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
;;        ;;       orderless-component-separator #'orderless-escapable-split-on-space)
;;        (setq completion-styles '(orderless basic)
;;              completion-category-defaults nil
;;              completion-category-overrides '((file (styles partial-completion)))))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c C-k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x C-b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x C-4 C-b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x C-5 C-b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer

         ("C-'" . consult-register-load)
         ("C-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> C-a" . consult-info)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g C-e" . consult-compile-error)
         ("M-g C-f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g C-o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g M-m" . consult-mark)
         ("M-g C-k" . consult-global-mark)
         ("M-g C-i" . consult-imenu)
         ("M-g C-I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s C-d" . consult-find)
         ("M-s C-D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s C-r" . consult-ripgrep)
         ("M-s M-s" . consult-line)
         ("M-s C-L" . consult-line-multi)
         ("M-s M-m" . consult-multi-occur)
         ("M-s C-k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s C-e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s C-e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s M-s" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s C-L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key "M-.")

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
)

;; Enable vertico-multiform
(vertico-multiform-mode)

;; Configure the display per command.
;; Use a buffer with indices for imenu
;; and a flat (Ido-like) menu for M-x.
(setq vertico-multiform-commands
      '((consult-imenu buffer indexed)
	(tmm-menubar flat)
	(tmm-shortcut grid)
	(ffap-menu unobtrusive)))

;; Configure the display per completion category.
;; Use the grid display for files and a buffer
;; for the consult-grep commands.
(setq vertico-multiform-categories
      '((consult-grep buffer)))

(advice-add #'tmm-add-prompt :after #'minibuffer-hide-completions)

(setq
  rmail-primary-inbox-list '("pops://j2a2m2all%40gmail.com:clxspoobpmzmiory@pop.gmail.com")
  rmail-preserve-inbox t
  user-full-name "Brandon Ellington"
  rmail-file-name    "~/.local/var/mail/guest"
  rmail-default-file "~/mail/saved"
  rmail-secondary-file-directory "~/mail"
  message-default-headers "Fcc: ~/mail/sent"
  user-mail-address "j2am2all@gmail.com")

(setq read-mail-command 'rmail)
;; (setq message-signature "--Brandon") ; see message signature file variable

(define-key minibuffer-local-map (kbd "M-.") #'my-embark-preview)
(defun my-embark-preview ()
  "Previews candidate in vertico buffer, unless it's a consult command."
  (interactive)
  (unless (bound-and-true-p consult--preview-function)
    (save-selected-window
      (let ((embark-quit-after-action nil))
        (embark-dwim)))))

;; Enable richer annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

(with-eval-after-load 'geiser-guile
       (add-to-list 'geiser-guile-load-path "~/src/guix/repos/guix-repo"))

(add-hook 'vc-annotate-mode-hook #'scroll-all-mode)

;; (setq-default header-line-format
;;       (prog1 mode-line-format
;; 	(setq-default mode-line-format
;; 	      header-line-format)))


(define-key isearch-mode-map (kbd "C-/") #'avy-isearch)
(global-set-key (kbd "C-x M-s") #'avy-resume)
;; (global-set-key (kbd "M-n") #'avy-next)
;; (global-set-key (kbd "M-p") #'avy-prev)
(global-set-key (kbd "C-,") #'avy-pop-mark)
(global-set-key (kbd "M-s C-s") #'isearch-forward)
(global-set-key (kbd "C-c C-<return>") #'consult-mode-command)

(use-package detached
  :init
  (detached-init)
  :bind (;; Replace `async-shell-command' with `detached-shell-command'
         ([remap async-shell-command] . detached-shell-command)
         ;; Replace `compile' with `detached-compile'
         ([remap compile] . detached-compile)
         ([remap recompile] . detached-compile-recompile)
         ;; Replace built in completion of sessions with `consult'
         ([67108900] . 'detached-open-session)
         ([67108897] . 'shell-command)
         ([remap detached-open-session] . detached-consult-session))
  :custom ((detached-show-output-on-attach t)
           (detached-terminal-data-command system-type)))

(with-eval-after-load 'embark
    (fset 'embark-collect-swoop-down
          (kmacro-lambda-form [?\C-n return] 0 "%d"))
    (define-key embark-collect-mode-map (kbd "M-n") 'embark-collect-swoop-down)

    (fset 'embark-collect-swoop-up
          (kmacro-lambda-form [?\C-p return] 0 "%d"))
    (define-key embark-collect-mode-map (kbd "M-p") 'embark-collect-swoop-up)

    (add-hook 'embark-collect-mode-hook #'embark-collect-direct-action-minor-mode))

  (global-set-key [remap query-replace] 'anzu-query-replace)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (define-key isearch-mode-map [remap isearch-query-replace]  #'anzu-isearch-query-replace)
  (define-key isearch-mode-map [remap isearch-query-replace-regexp] #'anzu-isearch-query-replace-regexp)

(defun avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

(defun aw-isearch-forward (window)
  "Perform 'isearch-forward' in WINDOW."
    (select-window window) (isearch-forward))

(with-eval-after-load 'avy
   (setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark))
   ;; (setf (alist-get ?/ aw-dispatch-alist) 'aw-isearch-forward)

;; (with-eval-after-load 'tempel
;;         ;; Ensure tempel-path is a list -- it may also be a string.
;;         (unless (listp 'tempel-path)
;;           (setq tempel-path (list tempel-path)))
;;         (add-to-list 'tempel-path "~/src/guix/repos/guix-repo/etc/snippets/tempel/*"))

;; (use-package vc-fossil
;;   ;; Keep from loading unnecessarily at startup.
;;   :defer t
;;   ;; This allows VC to load vc-fossil when needed.
;;   :init (add-to-list 'vc-handled-backends 'Fossil t))

;; (imenu-list-minor-mode)
(global-set-key [67108898] 'imenu-list-smart-toggle)

(setq-local prop-menu-item-functions
              (list (lambda (plist)
                      (let ((face (plist-get plist 'face)))
                        (when face
                          (list (list "Describe face" (lambda ()
                                                        (interactive)
                                                        (describe-face face)))))))))

;; (setq epa-pinentry-mode 'loopback)
;; (setq epg-pinentry-mode 'loopback)
;; (pinentry-start)
;; (shell-command "gpg-connect-agent /bye")
;; (auth-source-pass-enable)

(winner-mode)

(outline-minor-mode 1)
(transient-define-prefix outline-navigate ()
            :transient-suffix     'transient--do-stay
            :transient-non-suffix 'transient--do-warn
            [("p" "previous visible heading" outline-previous-visible-heading)
             ("n" "next visible heading" outline-next-visible-heading)])

;; for eieio classes, see the with-slots (spec-list) part of the info
;; manual.

;;; TODO Use git log as command history for emacs shell command:
;; hook shell command to git repository, commit buffer on every
;; execution. Try org-annalist.

;; NOTE need a %summary and/or %key prelude for smoother rec-mode
;; functionality.
(transient-define-suffix bran/guix-package-search ()
  "Run a search ('guix package -s') with the selected options."
  :transient 'transient--do-exit
  (interactive)
  (let* ((options (transient-args (oref transient-current-prefix command)))
         (command (concat "guix package " (combine-and-quote-strings options)))
	 (buf (get-buffer-create (concat "*Transient command: " command "*"))))
    (with-current-buffer buf
      (erase-buffer)
      (shell-command command buf)
      (beginning-of-buffer)
      (insert "%rec: Package\n")
      (insert (concat "%doc: From '" command "' \n"))
      (insert "%summary: name,synopsis\n\n")
      (rec-mode)
      (rec-cmd-show-summary))))

;; tip for consult/embark hook: use (rec-log-current-defun) to capture
;; selected values. Try shortdoc for quick sanity check, example:
;; select "name: emacs-python-black" => "emacs-python-black". Also see
;; (rec-field-value (rec-current-field)) for getting non-key values,
;; example: "location: foo/bar/etc.scm:123:4" =>
;; "foo/bar/etc.scm:123:4".

(transient-define-argument guix-search ()
  "Options used in a 'guix package -s FOO' command invovation."
  :class 'transient-option
  :description "Search for packages in current guix channels."
  ;; :key "-s"
  :argument "--search="
  ;; :shortarg "-s"
  :multi-value 'repeat)

(transient-define-prefix bran/guix-search-transient ()
  "Transient for guix search."
  ["Guix Search Options (comma separated)"
    ("-s" "--search=" guix-search)]
   ["Guix Search Action"
    ("r" "Run" bran/guix-package-search)])

(with-eval-after-load 'flymake
  (defun my-search-for-message (event)
    (interactive "e")
    (let* ((diags (flymake-diagnostics (posn-point (event-start event))))
           (topmost-diag (car diags)))
      (eww-browse-url
       (concat
        "https://duckduckgo.com/?q="
        (replace-regexp-in-string
         " " "+" (flymake-diagnostic-text topmost-diag)))
       t)))

  (dolist (type '(:warning :error))
    (push '(mouse-face . highlight) (get type 'flymake-overlay-control))
    (push `(keymap . ,(let ((map (make-sparse-keymap)))
                        (define-key map [mouse-2]
				    'my-search-for-message)
                        map))
          (get type 'flymake-overlay-control))))

;; Improvement ideas: using org-refile or capture, eieio to reduce coupling.
(defun bran/guix-package-search-org (opts)
  "Small command line wrapper over `guix search'.

Formats entries in 'org-mode' columns view.  See info(Invoking guix
package: 'guix-search') for information on running the command.
OPTS is what follows guix search and precedes the '| recfmt'
command, which should be a list of packages."
  (interactive "sPackages to search: ")
  (require 'org)
  (require 'consult-imenu)
  (let ((org-startup-folded 'show2levels)
	(guix-search-results-buf (get-buffer-create "*Org Guix Search Output*"))
	(shell-command-dont-erase-buffer 'erase)
	(consult-after-jump-hook (lambda () (recenter 4) (org-cycle 4))))
    (with-current-buffer guix-search-results-buf
      (shell-command
       (concat "guix search " opts
	       " | recfmt -f " (expand-file-name "~/guix-search-to-org.templ"))
       (current-buffer))
      (org-mode)
      (beginning-of-buffer)
      (insert (concat "* Package Search: " opts "\n"))
      ;; (org-global-cycle)
      (org-columns 4 "%25Item %Synopsis %Version %8License %2Relevance"))
    (consult-imenu-multi '(:include "*Org Guix"))))

;; (with-current-buffer (get-buffer "*Org Guix Search Output*")
;;   (org-map-entries
;;    '(org-entry-put
;;      nil "Module"
;;      (string-join
;;       (split-string
;;        (string-remove-suffix ".scm"
;; 			     (car
;; 			      (split-string
;; 			       (org-entry-get nil "Location")
;; 			       ":")))
;;        "/")
;;       " "))
;;    "+LEVEL=2")
;;   (format "(use modules %s)"
;; 	  (mapconcat
;; 	   (lambda (module) (format "(%s)" module))
;; 	   (org-property-values "Module") "\n")))

;; (with-current-buffer (get-buffer "*Org Guix Search Output*")
;;   (org-map-entries '(org-entry-get nil "Name") "+LEVEL=2"))

;; (org-insert-property-drawer) (org-entry-put sql-column sql-value) ;; for sql scripting.
;; (org-buffer-property-keys) ;; for org->sql, perhaps substituting a columns operation.

;;; Consult Built-in Enhancements
;;;; vc-change-log - the buffer inserts and deletes text manually, this needs work.
(defun bran/consult-vc-change-log (pos &rest args)
       (interactive "d")
       (let ((consult-after-jump-hook (recenter 4)))
	 (call-interactively #'consult-outline)))

(defalias 'that-buffer-goes-here
   (kmacro "C-x o C-x <left> C-x o C-x <right>"))
(define-key global-map (kbd "C-x <up>") 'that-buffer-goes-here)

(defalias 'this-buffer-goes-there
   (kmacro "C-x <left> C-x o C-x <right>"))
(define-key global-map (kbd "C-x <down>") 'this-buffer-goes-there)

(defun unpackaged/imenu-eww-headings ()
    "Return alist of HTML headings in current EWW buffer for Imenu.

Suitable for `imenu-create-index-function'."
    (let ((faces '(shr-h1 shr-h2 shr-h3 shr-h4 shr-h5 shr-h6 shr-heading)))
      (save-excursion
        (save-restriction
          (widen)
          (goto-char (point-min))
          (cl-loop for next-pos = (next-single-property-change (point) 'face)
                   while next-pos
                   do (goto-char next-pos)
                   for face = (get-text-property (point) 'face)
                   when (cl-typecase face
                          (list (cl-intersection face faces))
                          (symbol (member face faces)))
                   collect (cons (buffer-substring (point-at-bol) (point-at-eol)) (point))
                   and do (forward-line 1))))))

(add-hook 'eww-mode-hook
          (lambda ()
            (setq-local imenu-create-index-function #'unpackaged/imenu-eww-headings)))

;;; Emacs VC automation
;; (let ((default-directory "/tmp/browse-vc"))
;;   (make-directory default-directory)
;;   (vc-create-repo 'git)
;;   (vc-dir default-directory))

;;; Viewing function
;; (embark-live)
(defun bran/vc-browse (directory url &rest args)
  (interactive "GWhich Directory \nsWhich url ")
  (bran/browse-url-git url directory))

;; Fix function to use file-directory-p or another way to track
;; existing vc directory.
(defun bran/browse-url-git (url dir &rest args)
  (require 'vc-git)
  (let ((default-directory (expand-file-name dir))
	(clone-dir (concat (expand-file-name dir) (file-name-base url))))
    (mkdir (file-name-base url))
    (dired (vc-git-clone url clone-dir nil))
    ;; (dired-git-info-mode)
    (split-window-below)
    (shrink-window-if-larger-than-buffer)
    (other-window 1)
    (find-file-read-only (or "README.org" "README"))))

(defun browse-url-git (url &rest args)
  (require 'vc-git)
  (let ((default-directory browse-url-temp-dir)
	(clone-dir (concat browse-url-temp-dir (file-name-base url))))
    (unless (file-exists-p clone-dir)
      (mkdir (file-name-base url)))
    (dired (vc-git-clone url clone-dir nil))
    ;; (dired-git-info-mode)
    (split-window-below)
    (shrink-window-if-larger-than-buffer)
    (other-window 1)
    (find-file-read-only "README*" t)))

(defun meow-setup ()
  "Setup meow."
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
    (meow-motion-overwrite-define-key
     '("j" . meow-next)
     '("k" . meow-prev)
     '("<escape>" . ignore))
    (meow-leader-define-key
     ;; SPC j/k will run the original command in MOTION state.
     '("j" . "H-j")
     '("k" . "H-k")
     ;; Use SPC (0-9) for digit arguments.
     '("1" . meow-digit-argument)
     '("2" . meow-digit-argument)
     '("3" . meow-digit-argument)
     '("4" . meow-digit-argument)
     '("5" . meow-digit-argument)
     '("6" . meow-digit-argument)
     '("7" . meow-digit-argument)
     '("8" . meow-digit-argument)
     '("9" . meow-digit-argument)
     '("0" . meow-digit-argument)
     '("/" . avy-goto-char-timer)
     '(";" . embark-act)
     '("," . pop-global-mark)
     '("w" . ace-window))
    (meow-normal-define-key
     '("0" . meow-expand-0)
     '("9" . meow-expand-9)
     '("8" . meow-expand-8)
     '("7" . meow-expand-7)
     '("6" . meow-expand-6)
     '("5" . meow-expand-5)
     '("4" . meow-expand-4)
     '("3" . meow-expand-3)
     '("2" . meow-expand-2)
     '("1" . meow-expand-1)
     '("-" . negative-argument)
     '("%" . meow-reverse)
     '("[" . meow-beginning-of-thing)
     '("]" . meow-end-of-thing)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("c" . ctrl-c-keypad-menu)
     '("C" . meow-change)
     '("d" . meow-kill)
     '("D" . kill-line)
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("f" . meow-find)
     '("G" . meow-cancel-selection)
     '("g" . go-keypad-menu)
     '("q" . meow-grab)
     '("h" . meow-left)
     '("H" . meow-left-expand)
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("j" . meow-next)
     '("J" . meow-next-expand)
     '("k" . meow-prev)
     '("K" . meow-prev-expand)
     '("l" . meow-right)
     '("L" . meow-right-expand)
     '("M" . cycle-spacing)
     '("m" . consult-register-store)
     '("'" . consult-register-load)
     '(";" . meow-search)
     '("o" . meow-block)
     '("O" . meow-to-block)
     '("p" . meow-yank)
     '("@" . consult-kmacro)
     '("Q" . meow-quit)
     '("#" . meow-goto-line)
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
     '("S" . meow-select)
     '("t" . meow-till)
     '("u" . meow-undo)
     '("U" . meow-undo-in-selection)
     '("?" . isearch-backward-regexp)
     '("/" . isearch-forward-regexp)
     '("\\" . embark-act)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
     '("v" . meow-visit)
     '("V" . meow-line)
     '("y" . meow-save)
     '("Y" . meow-sync-grab)
     '("X" . meow-pop-selection)
     '(":" . viper-ex)
     '("+" . balance-windows)
     '("=" . quick-calc)
     '("s" . avy-goto-char-2)
     '("x" . ctrl-x-keypad-menu)
     '("z" . outline-keypad-menu)
     '("(" . insert-parentheses)
     '(")" . move-past-close-and-reindent)
     '("{" . backward-paragraph)
     '("}" . forward-paragraph)
     '(">" . meow-indent)
     '("<" . meow-back-to-indentation)
     '("." . repeat)
     '("~" . viper-toggle-case)
     '("<escape>" . ignore)))

(defvar meow-select-menu (make-sparse-keymap "Select"))
(define-key meow-select-menu [select-inner]
	    '(menu-item "Inner" meow-inner-of-thing))
(define-key meow-select-menu [select-bounds]
	    '(menu-item "Around bounds" meow-bounds-of-thing))

(defun go-keypad-menu ()
  "Meow shortcut to 'M-g' bindings."
  (interactive)
  (meow-keypad-start-with "M-g"))

(defun search-keypad-menu ()
  "Meow shortcut to 'M-s' bindings."
  (interactive)
  (meow-keypad-start-with "M-s"))

(global-set-key (kbd "M-g C-s") #'search-keypad-menu)
(global-set-key (kbd "M-g C-q") #'fill-paragraph)

(defun ctrl-x-keypad-menu ()
  "Meow shortcut to 'C-x' bindings."
  (interactive)
  (meow-keypad-start-with "C-x"))

(defun ctrl-c-keypad-menu ()
  "Meow shortcut to 'C-c' bindings."
  (interactive)
  (meow-keypad-start-with "C-c"))

(defun outline-keypad-menu ()
  "Meow shortcut to 'outline-minor-mode' bindings."
  (interactive)
  (outline-minor-mode 1)
  (meow-keypad-start-with "C-c @"))

(require 'key-chord)
(key-chord-mode 1)

(key-chord-define global-map "''" #'pop-to-mark-command)
(key-chord-define global-map "@@" #'meow-end-or-call-kmacro)
(key-chord-define global-map "gg" #'beginning-of-buffer)
(key-chord-define global-map "``" #'end-of-buffer)
(key-chord-define global-map "00" #'beginning-of-line)

(defun meow-select ()
  "Redefining meow's inner/bounds objects into a text menu."
  (interactive)
  (tmm-prompt meow-select-menu))

(require 'meow)
(require 'viper-cmd)
(require 'viper-ex)
(meow-setup)
(meow-global-mode 1)

;; (defvar-keymap embark-versioned-url-map
;;        :doc "Keymap for remote repository urls."
;;        :parent embark-url-map
;;        "g" #'vc-git-clone)
;;        ;; "f" #'vc-fossil-repository-url
;;        ;; "x" #'guix-packages-by-name-regexp

;;; Emacs notes
;; (server-start) TODO: integrate erc with matterbridge and webxdc/delta chat.

;; Alternative TODO: "wit" wisp + vnlog + git for ETL UI under version
;; control. Sparql, dired, odbc, and sqlite VFS can help with sourcing
;; data. Use custom/eieio interfaces to test writing schemas to go
;; into org-mode.

;;;; json/nested list to org-columns-view,
;; (setq test-org-json (json-read-object))
;; (org-insert-heading)

;; alist style (default):
;; (insert (cdr (assq 'by test-org-json)) "\n" (cdr (assq 'text test-org-json)))

;; hash style
;; (insert (gethash "by" test-org-json) "\n" (gethash "text" test-org-json))

;; hash with completion
;; (insert
;;  (gethash
;;   (completing-read
;;    "Keys: " (hash-table-keys test-org-json))
;;   test-org-json)
;;  "\n"
;;  (gethash
;;   (completing-read
;;    "Keys: " (hash-table-keys test-org-json))
;;   test-org-json)
;;  "\n")

;;;; test magit section for json->org-mode. Sections:
;;;;; Heading
;;;;; Property
;;;;; Text
;;;;; Block/Drawer

;;; Org feed (atom feed)
(defun bran/org-feed-url-at-point (url &rest _args)
  "Take URL at point, return 'org-mode' buffer as rss."
  (interactive (list (shr-url-at-point current-prefix-arg)))
  (let ((org-feed-alist `(("Reddit comments" ,(concat url ".rss") "/tmp/comments.org" "Reddit comments" :parse-feed org-feed-parse-atom-feed :parse-entry org-feed-parse-atom-entry))))
    (add-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (org-feed-update-all)
    (remove-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (switch-to-buffer "*Reddit RSS Comments*")))

(defun bran/org-feed-url-at-point-2 (url &rest _args)
  "Take URL at point, return 'org-mode' buffer as rss."
  (interactive (list (shr-url-at-point current-prefix-arg)))
  (let ((feed (concat url ".rss")))
    (add-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (eval `(org-feed-update '("Reddit comments" ,feed "/tmp/comments.org" "Reddit comments" :parse-feed org-feed-parse-atom-feed :parse-entry org-feed-parse-atom-entry)))
    (remove-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (switch-to-buffer "*Reddit RSS Comments*")))

(defun bran/org-feed-url-at-point-3 (url &rest _args)
  "Take URL at point, return 'org-mode' buffer as rss."
  (require 'org)
  (let ((feed (concat url ".rss")))
    (add-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (eval `(org-feed-update '("Reddit comments" ,feed "/tmp/comments.org" "Reddit comments" :parse-feed org-feed-parse-atom-feed :parse-entry org-feed-parse-atom-entry)))
    (remove-hook 'org-feed-after-adding-hook #'bran/org-feed-html-to-org)
    (switch-to-buffer "*Reddit RSS Comments*")))

;; in /tmp/comments.org buffer, change html to org-syntax
(defun bran/org-feed-html-to-org ()
  "Change html in feed entries to org."
  (with-current-buffer (get-file-buffer "/tmp/comments.org")
    (mark-whole-buffer)
    (org-next-visible-heading 2)
    (prog1
	(org-map-entries (lambda ()
			   (forward-line)
			   (org-mark-element)
			   (shell-command-on-region
			    (region-beginning) (region-end)
			    "pandoc -f html -t org" nil t))
			 nil 'region)
      (rename-buffer "*Reddit RSS Comments*")
      (delete-file "/tmp/comments.org")
      (not-modified))))

(load custom-file)
;; make transient interface that determines heading, text, and
;; properties; or use org-macro.

;; emacs in the browser
;; guix shell gtk+:bin -- broadwayd :5 &
;; GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 guix shell emacs-next-pgtk -- emacs

;; Other: Guix shell and emacs integration. Remote
;; org-tables->easy-menu. eieio->speedbar.

;; Local Variables:
;; compile-command: "guix home reconfigure home-configuration.scm"
;; End:
