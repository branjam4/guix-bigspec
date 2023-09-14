;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu packages)
	     (gnu packages base)
	     (gnu packages package-management)
             (gnu services)
             (guix gexp)
	     (guix channels)
             (gnu home services shells)
             (gnu home services mcron)
	     (gnu home services shepherd)
	     (gnu home services desktop)
	     (gnu home services guix)
	     (gnu home services)
	     (rnrs io simple)
	     (rnrs io ports))

(home-environment
 (packages
  (specifications->packages
   (string-split (string-trim-right (get-string-all (open-input-file "new.txt"))
				    #\newline)
		 #\newline)))
 (services
  (list (service
         home-bash-service-type
         (home-bash-configuration
          (aliases
           '(("grep" . "grep --color=auto")
             ("ll" . "ls -l")
             ("ls" . "ls -p --color=auto")))
          (bashrc
           (list (local-file
                  "/home/branjam/src/guix/.bashrc"
                  "bashrc")))
          (bash-profile
           (list (local-file
                  "/home/branjam/src/guix/.bash_profile"
                  "bash_profile")))))
	(simple-service 'some-useful-env-vars-service
          		home-environment-variables-service-type
          		`(("GUIX_EXTENSIONS_PATH" . "/home/branjam/.guix-home/profile/share/guix/extensions/")))
	(service home-files-service-type `((".emacs" ,(local-file "/home/branjam/src/guix/.emacs" "emacs"))))
	(service home-dbus-service-type)
	(simple-service 'variant-packages-service
                        home-channels-service-type
                        (list
                         (channel
                          (name 'bran-packages)
                          (url "https://github.com/branjam4/bran-channel.git")
			  (branch "main")
			  (introduction
			   (make-channel-introduction
			    "75bdc9767ed0ff212ac75f80c9bf0922841d4716"
		       	    (openpgp-fingerprint "0C7B 33F7 5485 9B8E D5C3  EB79 5CF6 7F7F 58DF CB5B"))))
			 (channel
			  (name 'nonguix)
			  (url "https://gitlab.com/nonguix/nonguix")
			  ;; Enable signature verification:
			  (introduction
			   (make-channel-introduction
			    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
			    (openpgp-fingerprint
			     "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))))))
