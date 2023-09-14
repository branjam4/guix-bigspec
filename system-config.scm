;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
 (gnu)
 (gnu services vnc)
 (gnu services dns)
 (gnu services nfs)
 (gnu services networking)
 (gnu system linux-container)
 (gnu system setuid)
 (guix)
 (guix utils)
 (guix profiles)
 (guix packages)
 (srfi srfi-1))
(use-service-modules avahi desktop networking ssh sddm mcron
                     xorg docker vpn kerberos sound shepherd
                     monitoring version-control authentication
                     databases audio nfs spice)
(use-package-modules base nfs linux)

(define updatedb-job
       ;; Run 'updatedb' at 3AM every day.  Here we write the
       ;; job's action as a Scheme procedure.
       #~(job '(next-minute-from (next-hour '(4 20)) '(28))
              (lambda ()
                (execl (string-append #$findutils "/bin/updatedb")
                       "updatedb"
                       "--prunepaths=/tmp /var/tmp /gnu/store"))
              "updatedb"))

(operating-system
 (locale "en_US.utf8")
 (locale-libcs (list (canonical-package glibc)))
 (timezone "America/Los_Angeles")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "inspirix")
 (users (cons* (user-account
                (name "branjam")
                (comment "Brandon Ellington")
                (group "users")
                (home-directory "/home/branjam")
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))
 (packages
  (append
   (map specification->package
        '("i3-wm"
          "i3status"
          "dmenu"
          "st"
          "nss-certs"
          "avahi"
          "gnome-disk-utility"
          "ntfs-3g"
          "gvfs"
          "docker-cli"
          "picom"
          "dunst"
          "vlc"
          "xf86-video-qxl"
          "openldap"
          "mit-krb5"
          ;; "nss-pam-ldapd"
          "stumpwm-with-slynk"
          "sbcl-stumpwm-swm-gaps"
          "emacs-stumpwm-mode"
          "sbcl-stumpwm-globalwindows"
          "sbcl-stumpwm-ttf-fonts"
          "sbcl-stumpwm-stumptray"
          "sbcl-stumpwm-net"))
   %base-packages))
 (services
  (append
   (list (service openssh-service-type
                  (openssh-configuration
                   (allow-empty-passwords? #t)
                   (gateway-ports? #t)))
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout)))
	 (service xvnc-service-type (xvnc-configuration
                                     (display-number 5)
                                     (xdmcp? #t)
                                     (inetd? #t)))
         (service xfce-desktop-service-type)
         (service gnome-desktop-service-type)
         (service dnsmasq-service-type
		  (dnsmasq-configuration
		   (port 0)
		   (tftp-enable? #t)
		   (tftp-root "/var/lib/netspirix/boot")))
	 (service nfs-service-type
		  (nfs-configuration
		   (exports
		    '(("/var/lib/netspirix"
		       "*(rw,insecure,no_subtree_check,\
crossmnt,fsid=root,no_root_squash,insecure,async)")))
		   (nfs-versions '("4.2" "4.1"))
		   (debug (list 'nfsd 'nfs 'idmap 'mountd))))
         (service wireguard-service-type
                  (wireguard-configuration
                   (addresses '("192.168.10.1/32"))))
         ;; (service pam-krb5-service-type (pam-krb5-configuration))
         (service nslcd-service-type (nslcd-configuration))
         ;; (service pagekite-service-type (pagekite-configuration))
         (simple-service 'my-cron-jobs mcron-service-type
                         (list updatedb-job))
         (service mpd-service-type (mpd-configuration))
         ;; (service tailon-service-type)
         ;; (service zabbix-server-service-type (zabbix-server-configuration))
         ;; (service zabbix-agent-service-type (zabbix-agent-configuration))
         ;; (service zabbix-front-end-service-type (zabbix-front-end-configuration))
         ;; (service gitolite-service-type (gitolite-configuration)) ;get public key
         (service redis-service-type (redis-configuration))
         ;; (service docker-service-type (docker-configuration))
         ;; (service singularity-service-type)
)
   (modify-services
    %desktop-services
    (gdm-service-type config => (gdm-configuration
                                 (inherit config)
                                 (auto-suspend? #f)
                                 (xdmcp? #t))))))
 (setuid-programs
         (append (list (setuid-program
                        (program (file-append nfs-utils "/sbin/mount.nfs")))
			(setuid-program
			 (program (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
                 %setuid-programs))
 (name-service-switch
       (let ((services (list (name-service (name "db"))
                             (name-service (name "files"))
                             (name-service (name "ldap")))))
         (name-service-switch
          (inherit %mdns-host-lookup-nss)
          (password services)
          (shadow   services)
          (group    services)
          (netgroup services)
          (gshadow  services))))
 (bootloader
  (bootloader-configuration
   (bootloader grub-bootloader)
   (targets '( "/dev/sda"))
   (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space (target "/dev/sda1"))))
 (file-systems
  (cons* (file-system
           (mount-point "/")
           (device
            (uuid "ca3c2ded-fc9c-4e20-a647-2c34bb5b0187"
                  'ext4))
           (type "ext4"))
	 (file-system
	   (mount-point "/share")
	   (device "/dev/sdb1")
	   (type "ntfs")
	   (flags '(shared)))
         %base-file-systems)))
