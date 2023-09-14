;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-mode-hook '(turn-on-font-lock meow-insert-mode))
 '(archive-zip-extract '("guix" "shell" "unzip" "--" "unzip" "-qq" "-c"))
 '(avy-all-windows-alt t)
 '(avy-single-candidate-jump nil)
 '(browse-url-handlers
   '(("reddit\\.com" . bran/org-feed-url-at-point-3)
     ("git\\(hub\\|lab\\)\\.com" . browse-url-git)
     ("git\\.savannah\\.gnu\\.org/git/.+\\.git" . browse-url-git)
     ("\\.git$" . browse-url-git)))
 '(connection-local-criteria-alist
   '(((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(consult-after-jump-hook '((lambda nil (recenter 4))))
 '(custom-safe-themes
   '("1781e8bccbd8869472c09b744899ff4174d23e4f7517b8a6c721100288311fa5" "de8f2d8b64627535871495d6fe65b7d0070c4a1eb51550ce258cd240ff9394b0" "e7820b899036ae7e966dcaaec29fd6b87aef253748b7de09e74fdc54407a7a02" "351473429145eddc87779a0d9700261073fe480c1e4e35b066a01d6a10c0eedb" "f0eb51d80f73b247eb03ab216f94e9f86177863fb7e48b44aacaddbfe3357cf1" "db5b906ccc66db25ccd23fc531a213a1afb500d717125d526d8ff67df768f2fc" "98fada4d13bcf1ff3a50fceb3ab1fea8619564bb01a8f744e5d22e8210bfff7b" default))
 '(dirvish-attributes nil)
 '(dirvish-override-dired-mode t)
 '(dirvish-override-dired-mode-hook nil)
 '(dirvish-peek-mode t)
 '(dirvish-peek-mode-hook nil)
 '(dynamic-completion-mode t)
 '(ede-project-directories '("/home/branjam/repos/gusteau"))
 '(elfeed-feeds
   '("https://www.youtube.com/feeds/videos.xml?channel_id=UCY6Ij8zOds0WJEeqCLOnqOQ"))
 '(embark-indicators
   '(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator))
 '(eww-after-render-hook '((lambda nil (text-scale-set -2))))
 '(global-srecode-minor-mode t)
 '(gnus-secondary-select-methods '((nntp "news.gwene.org")))
 '(gnus-select-method
   '(nnimap "gmail"
	    (nnimap-stream ssl)
	    (nnimap-server-port 993)
	    (nnimap-address "imap.gmail.com")))
 '(help-mode-hook '(meow-motion-mode))
 '(imenu-use-popup-menu t)
 '(meow-motion-mode-hook '(follow-mode))
 '(newsticker-url-list
   '(("r/Godot" "https://www.reddit.com/r/godot/.rss" nil nil nil)
     ("r/Keep Track" "https://www.reddit.com/r/Keep_Track/.rss" nil nil nil)
     ("r/Org Mode" "https://www.reddit.com/r/orgmode/.rss" nil nil nil)
     ("r/PowerApps" "https://www.reddit.com/r/PowerApps/.rss" nil nil nil)
     ("r/sqlite" "https://www.reddit.com/r/sqlite/.rss" nil nil nil)
     ("r/SharePoint" "https://www.reddit.com/r/sharepoint/.rss" nil nil nil)
     ("r/Programming" "https://www.reddit.com/r/programming/.rss" nil nil nil)
     ("r/plaintextaccounting" "https://www.reddit.com/r/plaintextaccounting/.rss" nil nil nil)
     ("r/emacs-reddit" "https://www.reddit.com/r/emacs/.rss" nil nil nil)
     ("r/Superstonk" "https://www.reddit.com/r/Superstonk/.rss" nil nil nil)
     ("r/Blender" "https://www.reddit.com/r/blender/.rss" nil nil nil)))
 '(org-confirm-babel-evaluate nil)
 '(orgtbl-radio-table-templates
   '((emacs-lisp-mode ";; #+ BEGIN RECEIVE ORGTBL %n\12;; #+ END RECEIVE ORGTBL %n\12(message \";; begin table\12#+ORGTBL: SEND %n orgtbl-to-generic :splice nil :skip 0\12| | |\12;; end table\")\12")
     (latex-mode "% BEGIN RECEIVE ORGTBL %n\12% END RECEIVE ORGTBL %n\12\\begin{comment}\12#+ORGTBL: SEND %n orgtbl-to-latex :splice nil :skip 0\12| | |\12\\end{comment}\12")
     (texinfo-mode "@c BEGIN RECEIVE ORGTBL %n\12@c END RECEIVE ORGTBL %n\12@ignore\12#+ORGTBL: SEND %n orgtbl-to-html :splice nil :skip 0\12| | |\12@end ignore\12")
     (html-mode "<!-- BEGIN RECEIVE ORGTBL %n -->\12<!-- END RECEIVE ORGTBL %n -->\12<!--\12#+ORGTBL: SEND %n orgtbl-to-html :splice nil :skip 0\12| | |\12-->\12")
     (org-mode "#+ BEGIN RECEIVE ORGTBL %n\12#+ END RECEIVE ORGTBL %n\12\12#+ORGTBL: SEND %n orgtbl-to-orgtbl :splice nil :skip 0\12| | |\12")))
 '(package-selected-packages
   '(htmlize with-editor orderless leaf magit objed org-modern svg-lib svg-tag-mode annotate dict-tree frog-menu fsm ilist prop-menu ace-window advice-patch avy blist cape corfu crdt dired-du dired-git-info edit-indirect eev eglot el-search eldoc eldoc-eval marginalia minibuffer-header nano-agenda nano-modeline nano-theme eat vc-fossil))
 '(prog-mode-hook '(flymake-mode tempel-setup-capf))
 '(rec-mode-hook '(rec-update-buffer-descriptors))
 '(rec-open-mode 'edit)
 '(rec-summary-mode-hook
   '((lambda nil
       (setq-local consult-after-jump-hook
		   (lambda nil
		     (rec-summary-cmd-jump-to-record)
		     (switch-to-buffer
		      (string-trim-right
		       (buffer-name)
		       " Summary"))
		     (recenter -1))))) t)
 '(safe-local-variable-values
   '((run-command-recipe-dir-locals-fn lambda nil
				       (list
					(list :command-name "guix package emacs" :command-line "guix package -L ~/guix-extra-channels -m dev-emacs-manifest.scm -m extra-emacs-manifest.scm -m main-emacs-manifest.scm -m org-dependencies-manifest.scm -p ~/.guix-extra-profiles/emacs/emacs")))
     (eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (file-local-name
		    (expand-file-name root-dir-unexpanded)))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (org-html-head-include-scripts)
     (org-blank-before-new-entry
      (heading . auto)
      (plain-list-item . auto))
     (org-list-description-max-indent . 5)
     (org-list-two-spaces-after-bullet-regexp)
     (eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (expand-file-name root-dir-unexpanded))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew
		(expand-file-name "src" root-dir*)
		geiser-guile-load-path :test #'string-equal))))
     (eval progn
	   (require 'lisp-mode)
	   (defun emacs27-lisp-fill-paragraph
	       (&optional justify)
	     (interactive "P")
	     (or
	      (fill-comment-paragraph justify)
	      (let
		  ((paragraph-start
		    (concat paragraph-start "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
		   (paragraph-separate
		    (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
		   (fill-column
		    (if
			(and
			 (integerp emacs-lisp-docstring-fill-column)
			 (derived-mode-p 'emacs-lisp-mode))
			emacs-lisp-docstring-fill-column fill-column)))
		(fill-paragraph justify))
	      t))
	   (setq-local fill-paragraph-function #'emacs27-lisp-fill-paragraph))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (expand-file-name root-dir-unexpanded))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (eval with-eval-after-load 'yasnippet
	   (let
	       ((guix-yasnippets
		 (expand-file-name "etc/snippets/yas"
				   (locate-dominating-file default-directory ".dir-locals.el"))))
	     (unless
		 (member guix-yasnippets yas-snippet-dirs)
	       (add-to-list 'yas-snippet-dirs guix-yasnippets)
	       (yas-reload-all))))
     (eval setq-local guix-directory
	   (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-to-list 'completion-ignored-extensions ".go")))
 '(scheme-mode-hook '(geiser-mode--maybe-activate guix-devel-mode))
 '(special-mode-hook '(follow-mode) t)
 '(sr-speedbar-default-width 30)
 '(sr-speedbar-max-width 30)
 '(sr-speedbar-right-side nil)
 '(tempel-path
   '("/home/branjam/guix-config/repos/guix-repo/etc/snippets/tempel/*" "/home/branjam/.emacs.d/templates" "/home/branjam/guix-config/repos/tempel-collection/templates/*"))
 '(transient-display-buffer-action
   '(display-buffer-in-side-window
     (side . right)
     (dedicated . t)
     (inhibit-same-window . t)
     (window-parameters
      (no-other-window . t))))
 '(transient-force-single-column t)
 '(transient-semantic-coloring t)
 '(url-handler-mode t)
 '(view-mode-hook '(meow-insert-mode))
 '(view-read-only t)
 '(viper-vi-style-in-minibuffer nil)
 '(viper-want-ctl-h-help t)
 '(widget-image-enable nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
