;;; larder-first-run-test.el --- ERT checks for the Emacs first-run shell  -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Run by 5-TEST/lr1ck, never by hand:   LARDER_ROOT=/path/to/4-BUILD emacs --batch -Q ...
;; "Must RUN, not merely render": the buttons are pressed, a dispatcher is started,
;; and what it printed or recorded is read back.

;;; Code:

(require 'ert)
(require 'cl-lib)

(defvar larder-test-root
  (or (getenv "LARDER_ROOT") (error "LARDER_ROOT is not set")))

(load (expand-file-name "shell/larder-first-run.el" larder-test-root) nil t)

(defun larder-test--ids (profile edition)
  (let ((larder-first-run-profile profile) (larder-first-run-edition edition))
    (mapcar (lambda (c) (plist-get c :id)) (larder-first-run-choices))))

(defun larder-test--wait (proc)
  (let ((n 0))
    (while (and (process-live-p proc) (< n 100))
      (accept-process-output proc 0.1) (cl-incf n)))
  (accept-process-output nil 0.1))

(defun larder-test--button (id)
  "The button for choice ID in the current buffer."
  (let ((pos (point-min)) found)
    (while (and (not found) (setq pos (next-single-property-change pos 'larder-id)))
      (when (equal (get-text-property pos 'larder-id) id) (setq found pos)))
    (or found (and (equal (get-text-property (point-min) 'larder-id) id) (point-min)))))

(ert-deftest larder-test-offers-what-the-profile-has ()
  (should (equal (larder-test--ids "minimal" "base") '("try" "private" "chapter" "help")))
  (should (member "library" (larder-test--ids "desktop" "base")))
  (should-not (member "read" (larder-test--ids "desktop" "base")))
  (should (member "read" (larder-test--ids "desktop" "author")))
  (should-not (member "read" (larder-test--ids "minimal" "author"))))

(ert-deftest larder-test-click-starts-the-dispatcher ()
  "Press the button for PRIVATE; a stub dispatcher records what it was handed."
  (let* ((log (make-temp-file "larder-log"))
         (stub (make-temp-file "larder-stub" nil ".sh"))
         (larder-first-run-profile "hardened")
         (larder-first-run-edition "base")
         (larder-first-run-open-program stub))
    (with-temp-file stub
      (insert "#!/bin/sh\nprintf '%s|%s|%s\\n' \"$LARDER_PROFILE\" \"$LARDER_EDITION\" \"$*\" > " log "\n"))
    (set-file-modes stub #o700)
    (with-temp-buffer
      (larder-first-run-mode)
      (larder-first-run--render)
      (let ((pos (larder-test--button "private")))
        (should pos)
        (should (eq (button-get pos 'follow-link) t))      ; mouse-1 follows it
        (let ((before (process-list)))
          (push-button pos)
          (let ((proc (car (cl-set-difference (process-list) before))))
            (should proc)
            (larder-test--wait proc)))))
    (should (equal (string-trim (with-temp-buffer (insert-file-contents log) (buffer-string)))
                   "hardened|base|--run private"))
    (delete-file log) (delete-file stub)))

(ert-deftest larder-test-real-dispatcher-end-to-end ()
  "Button -> bin/lr1op -> out/choices.txt; dry, so it says what it would start."
  (let ((larder-first-run-profile "desktop") (larder-first-run-edition "base")
        (larder-first-run-run nil))
    (with-temp-buffer
      (larder-first-run-mode)
      (larder-first-run--render)
      (let ((before (process-list)))
        (push-button (larder-test--button "library"))
        (larder-test--wait (car (cl-set-difference (process-list) before))))
      (should (string-match-p "would run: kiwix-desktop" larder-first-run--status)))))

(ert-deftest larder-test-refusal-is-shown-in-words ()
  "A choice this edition does not offer is refused by the dispatcher and shown."
  (let ((larder-first-run-profile "minimal") (larder-first-run-edition "base")
        (larder-first-run-run nil))
    (with-temp-buffer
      (larder-first-run-mode)
      (larder-first-run--render)
      (larder-test--wait (larder-first-run--act "library"))
      (should (string-match-p "not offered on this edition" larder-first-run--status)))))

(ert-deftest larder-test-colours-work-both-ways ()
  (unwind-protect
      (progn
        (larder-first-run--set-theme 'dark)
        (should (memq 'modus-vivendi custom-enabled-themes))
        (larder-first-run--set-theme 'light)
        (should (memq 'modus-operandi custom-enabled-themes))
        (should-not (memq 'modus-vivendi custom-enabled-themes))
        (larder-first-run--set-theme 'default)
        (should-not custom-enabled-themes))
    (mapc #'disable-theme (copy-sequence custom-enabled-themes))))

(ert-deftest larder-test-kiosk-frame ()
  (with-temp-buffer
    (larder-first-run-mode)
    (should (null mode-line-format))
    (should buffer-read-only)
    (larder-first-run--render)
    (should (> (length (larder-first-run-choices)) 0))))

(provide 'larder-first-run-test)
;;; larder-first-run-test.el ends here
