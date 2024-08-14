;;; package --- early init -*- lexical-binding: t -*-

;;; Commentary:
;;; Prevents white flash and better Emacs defaults

;;; Code:
(set-language-environment "UTF-8")

(setq-default
 default-frame-alist
 '((background-color . "#3F3F3F")
   (bottom-divider-width . 1)            ; Thin horizontal window divider
   (foreground-color . "#DCDCCC")        ; Default foreground color
   (fullscreen . maximized)              ; Maximize the window by default
   (horizontal-scroll-bars . nil)        ; No horizontal scroll-bars
   (left-fringe . 8)                     ; Thin left fringe
   (menu-bar-lines . 0)                  ; No menu bar
   (right-divider-width . 1)             ; Thin vertical window divider
   (right-fringe . 8)                    ; Thin right fringe
   (tool-bar-lines . 0)                  ; No tool bar
   (undecorated . t)                     ; Remove extraneous X decorations
   (vertical-scroll-bars . nil))         ; No vertical scroll-bars

 user-full-name "Sandeep Nambiar"                                        ; ME!

 ;; memory configuration
 gc-cons-threshold most-positive-fixnum                                  ; Higher garbage collection threshold, prevents frequent gc locks
 byte-compile-warnings '(not obsolete)                                   ; Ignore warnings for (obsolete) elisp compilations
 warning-suppress-log-types '((comp) (bytecomp))                         ; And other log types completely
 large-file-warning-threshold 100000000                                  ; Large files are okay in the new millenium.
 read-process-output-max (max (* 10240 102400) read-process-output-max)  ; Read more based on system pipe capacity

 ;; scroll configuration
 scroll-margin 0                                                         ; Lets scroll to the end of the margin
 scroll-conservatively 100000                                            ; Never recenter the window
 scroll-preserve-screen-position 1                                       ; Scrolling back and forth between the same points

 ;; frame config
 frame-inhibit-implied-resize t                                          ; Improve emacs startup time by not resizing to adjust for custom settings
 frame-resize-pixelwise t                                                ; Dont resize based on character height / width but to exact pixels

 ;; backups & files
 backup-directory-alist '(("." . "~/.backups/"))                         ; Don't clutter
 backup-by-copying t                                                     ; Don't clobber symlinks
 create-lockfiles nil                                                    ; Don't have temp files, especially that trip the language servers
 delete-old-versions t                                                   ; Cleanup automatically
 kept-new-versions 6                                                     ; Update every few times
 kept-old-versions 2                                                     ; And cleanup even more
 version-control t                                                       ; Version them backups
 delete-by-moving-to-trash t                                             ; Dont delete, send to trash instead

 ;; startup
 inhibit-startup-screen t                                                ; I have already done the tutorial. Twice
 inhibit-startup-message t                                               ; I know I am ready
 inhibit-startup-echo-area-message t                                     ; Yep, still know it
 initial-scratch-message nil                                             ; I know it is the scratch buffer where I can write anything!

 ;; packages
 package-install-upgrade-built-in t                                      ; always upgrade built in packages
 use-package-always-ensure t                                             ; always ensure packages, first startup is slower

 ;; tabs
 tab-width 4                                                             ; Always tab 4 spaces.
 indent-tabs-mode nil                                                    ; Never use actual tabs.

 cursor-in-non-selected-windows nil                                      ; dont render cursors in non-selected windows

 ;; custom
 custom-file (concat user-emacs-directory "custom.el")

 load-prefer-newer t

 default-input-method nil
 )

;;; early-init.el ends here
