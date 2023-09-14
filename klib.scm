(use-modules (guix build utils)
	     (guix gexp)
	     (guix packages)
             (gnu packages)
             (gnu packages linux)
	     (gnu packages perl)
	     ;; (guix build gnu-build-system)
             (guix build-system gnu)
             (guix git-download)
	     ((guix licenses) #:prefix license:))

;; use "guix hash -x --serializer=nar" for git downloads.
(define klibc
  (package
    (name "klibc")
    (version "2.0.13")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://git.kernel.org/pub/scm/libs/klibc/klibc.git")
                    (commit (string-append name "-" version))
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
		"0yw586d28f7kpr9rw8d6vmkisrzbw2s7lfhm26j054bn1l8ngpa2"))))
    (build-system gnu-build-system)
    (arguments
     (list #:make-flags #~(list
			   (string-append
			    "KLIBCKERNELSRC=" #$linux-libre-headers-6.3)
			   ;; (string-append
			   ;;  "prefix=" #$output)
			   (string-append
			    "INSTALLROOT=" #$output))
	   #:phases #~(modify-phases %standard-phases
			(delete 'check)
			(delete 'configure))))
    (native-inputs (list perl))
    (propagated-inputs (list linux-libre-headers))
    (synopsis "Minimalistic libc subset for use with initramfs.")
    (description
     "This is klibc, what is intended to be a minimalistic libc subset for
use with initramfs.  It is deliberately written for small size,
minimal entanglement, and portability, not speed.  It is definitely a
work in progress, and a lot of things are still missing.")
    (home-page "https://git.kernel.org/pub/scm/libs/klibc/klibc.git/about")
    (license license:gpl2)))

;; Local Variables:
;; compile-command: "guix build -K -f klibc.scm"
;; compilation-read-command: nil
;; End:
