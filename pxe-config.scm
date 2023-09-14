;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
 (gnu)
 (gnu packages)
 (gnu services vnc)
 (gnu system linux-container)
 (guix)
 (guix build utils)
 (guix build-system gnu)
 (guix gexp)
 (guix git-download)
 ((guix licenses) #:prefix license:)
 (guix modules)
 (guix packages)
 (guix profiles)
 (guix utils)
 (nongnu packages linux)
 (nongnu system linux-initrd)
 (srfi srfi-1))

(use-service-modules avahi desktop networking ssh sddm mcron
                     xorg docker vpn kerberos sound shepherd
                     monitoring version-control authentication
                     databases audio nfs spice)
(use-package-modules base bootloaders file-systems linux nfs perl)

(load "linux-initrd.scm")
(load "klibc.scm")

(define updatedb-job
       ;; Run 'updatedb' at 3AM every day.  Here we write the
       ;; job's action as a Scheme procedure.
       #~(job '(next-minute-from (next-hour '(4 20)) '(28))
              (lambda ()
                (execl (string-append #$findutils "/bin/updatedb")
                       "updatedb"
                       "--prunepaths=/tmp /var/tmp /gnu/store"))
              "updatedb"))

;; (define %default-extra-linux-options
;;   (@@ (gnu packages linux) %default-extra-linux-options))

(define %extra-linux-options
  `(;; Make the kernel config available at /proc/config.gz
    ("CONFIG_IKCONFIG" . #t)
    ("CONFIG_IKCONFIG_PROC" . #t)
    ;; Some very mild hardening.
    ("CONFIG_SECURITY_DMESG_RESTRICT" . #t)
    ;; All kernels should have NAMESPACES options enabled
    ("CONFIG_NAMESPACES" . #t)
    ("CONFIG_UTS_NS" . #t)
    ("CONFIG_IPC_NS" . #t)
    ("CONFIG_USER_NS" . #t)
    ("CONFIG_PID_NS" . #t)
    ("CONFIG_NET_NS" . #t)
    ;; Various options needed for elogind service:
    ;; https://issues.guix.gnu.org/43078
    ("CONFIG_CGROUP_WRITEBACK" . #t)
    ("CONFIG_SOCK_CGROUP_DATA" . #t)
    ("CONFIG_CGROUP_NET_CLASSID" . #t)
    ("CONFIG_MEMCG" . #t)
    ("CONFIG_MEMCG_SWAP" . #t)
    ("CONFIG_MEMCG_KMEM" . #t)
    ("CONFIG_PROC_PID_CPUSET" . #t)
    ;; Allow disk encryption by default
    ("CONFIG_DM_CRYPT" . m)
    ;; Support zram on all kernel configs
    ("CONFIG_ZSWAP" . #t)
    ("CONFIG_ZSMALLOC" . #t)
    ("CONFIG_ZRAM" . m)
    ;; Accessibility support.
    ("CONFIG_ACCESSIBILITY" . #t)
    ("CONFIG_A11Y_BRAILLE_CONSOLE" . #t)
    ("CONFIG_SPEAKUP" . m)
    ("CONFIG_SPEAKUP_SYNTH_SOFT" . m)
    ;; Modules required for initrd:
    ("CONFIG_VIRTIO_BALLOON" . m)
    ("CONFIG_VIRTIO_MMIO" . m)
    ("CONFIG_FUSE_FS" . m)
    ("CONFIG_CIFS" . m)))

(define config->string
  (@@ (gnu packages linux) config->string))

(operating-system
  (locale "en_US.utf8")
  (locale-libcs (list (canonical-package glibc)))
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:swapcaps")))
  (host-name "netspirix")
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
	   "openssh"
           "avahi"
           "gnome-disk-utility"
           "ntfs-3g"
	   "nfs-utils"
	   "libnfs"
	   "autofs"
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
                    (gateway-ports? #t)
		    (x11-forwarding? #t)))
          (set-xorg-configuration
           (xorg-configuration
            (keyboard-layout keyboard-layout)))
	  (service xvnc-service-type (xvnc-configuration
                                      (display-number 5)
                                      (xdmcp? #t)
                                      (inetd? #t)))
          (service xfce-desktop-service-type)
          (service gnome-desktop-service-type)
          (service nfs-service-type
		   (nfs-configuration))
          (service wireguard-service-type
                   (wireguard-configuration
                    (addresses '("192.168.9.1/32"))))
          ;; (service pam-krb5-service-type (pam-krb5-configuration))
          (service nslcd-service-type (nslcd-configuration))
          ;; (service pagekite-service-type (pagekite-configuration))
          (simple-service 'my-cron-jobs mcron-service-type
                          (list updatedb-job))
	  (simple-service 'add-extra-hosts
                          hosts-service-type
                          (list (host "192.168.8.183" "inspirix")))
          (service mpd-service-type (mpd-configuration))
	  (service dhcp-client-service-type)
          ;; (service tailon-service-type)
          ;; (service zabbix-server-service-type (zabbix-server-configuration))
          ;; (service zabbix-agent-service-type (zabbix-agent-configuration))
          ;; (service zabbix-front-end-service-type (zabbix-front-end-configuration))
          ;; (service gitolite-service-type (gitolite-configuration)) ;get public key
          (service redis-service-type (redis-configuration))
          ;; (service docker-service-type (docker-configuration))
          ;; (service singularity-service-type)
	  )
    (remove (lambda (service)
              (let ((type (service-kind service)))
                (or (memq type
                          (list network-manager-service-type))
                    (eq? 'network-manager-applet
                         (service-type-name type)))))
            (modify-services
		%desktop-services
	      (gdm-service-type config => (gdm-configuration
					   (inherit config)
					   (auto-suspend? #f)
					   (xdmcp? #t)))))))
  (name-service-switch %mdns-host-lookup-nss)
  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-netboot-bootloader)
    (targets '( "/var/lib/netspirix/boot/"))
    (keyboard-layout keyboard-layout)
    (menu-entries
     (list
      (menu-entry
       (label "iPXE")
       (chain-loader #~(string-append #$ipxe "/lib/ipxe/ipxe.lkrn")))))))
  (initrd-modules (cons* "realtek" "r8169" "nfsv4" "nfs" %base-initrd-modules))
  (kernel-arguments
   (cons* "root=/dev/nfs" "nfsroot=192.168.8.183:/var/lib/netspirix,timeo=30" "ip=dhcp"
	  %default-kernel-arguments))
  ;; (kernel (customize-linux #:linux linux
  ;; 			   #:defconfig "x86_64_defconfig"
  ;; 			   #:configs (config->string %extra-linux-options)))
  ;; (kernel linux)
  ;; (initrd (lambda (file-systems . rest)
  ;; 	    (expression->initrd
  ;; 	     (with-imported-modules (source-module-closure
  ;; 				     '((guix build utils)))
  ;; 	       #~(begin
  ;; 		   (use-modules ((guix build utils) #:hide (delete)))
  ;; 		   (mkdir "bin")
  ;; 		   (mkdir "usr")
  ;; 		   (mkdir "sbin")
  ;; 		   (copy-recursively (string-append #$klibc "/lib") "/lib")
  ;; 		   (copy-recursively (string-append #$klibc "/usr") "/usr")
  ;; 		   (copy-file (string-append #$klibc "/usr/lib/klibc/bin/kinit") "/sbin/init")
  ;; 		   (execl "/sbin/init"))))))
  (initrd base-initrd)
  (firmware (list linux-firmware))
  (file-systems
   (cons* (file-system
            (device "192.168.8.183:/")
            (mount-point "/")
            (type "nfs4")
	    (options "addr=192.168.8.183"))
          %base-file-systems)))
  ;; (swap-devices (list (swap-space
  ;;                      (target "/run/swapfile")))))

;; Local Variables:
;; compile-command: "sudo guix system init pxe-config.scm /var/lib/netspirix/"
;; End:
