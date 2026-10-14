;;; larder-first-run.el --- Larder first-run shell, Emacs form  -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; What a newcomer sees on a console-only edition (minimal, homelab), or on a desktop
;; if they would rather have Emacs: one window, plain choices, a mouse is enough.
;; Start with:  emacs -nw -Q -l larder-first-run.el -f larder-first-run
;; (on a console-only Debian the program is emacs-nox: Debian's file lists show no
;; usr/bin/emacs in that package; the name emacs comes from an alternatives link.)
;;
;; It reads the same out/choices.txt as the HTML page and hands every click to
;; the same bin/lr1op, so the two shells cannot offer different things.
;;
;; Colours: in a window the Light and Dark buttons load Modus Operandi or Vivendi
;; (both ship with Emacs); "Emacs default" unloads them.  This frame does NOT follow
;; the computer's own light/dark setting (Emacs 29 has no portable way to ask); on a
;; text terminal the terminal's own colours govern and no colour buttons are shown.
;; On the bare Linux console the mouse needs gpm running (package gpm, in the
;; console profiles).  This file has been run in batch mode only, never on a screen.

;;; Code:

(require 'button)
(require 'subr-x)

(defgroup larder-first-run nil "Larder first-run shell." :group 'applications)

(defconst larder-first-run--dir
  (file-name-directory (or load-file-name buffer-file-name default-directory)))

(defcustom larder-first-run-choices-file
  (expand-file-name "../out/choices.txt" larder-first-run--dir)
  "The pipe-separated choices, generated from recipes.org."
  :type 'file)

(defcustom larder-first-run-open-program
  (expand-file-name "../bin/lr1op" larder-first-run--dir)
  "The dispatcher a click is handed to."
  :type 'file)

(defcustom larder-first-run-profile (or (getenv "LARDER_PROFILE") "minimal")
  "Which profile this stick was built from."
  :type 'string)

(defcustom larder-first-run-edition (or (getenv "LARDER_EDITION") "base")
  "Either base or author."
  :type 'string)

(defcustom larder-first-run-run t
  "Non-nil: a click starts the program.  Nil: it only says what it would start."
  :type 'boolean)

(defface larder-first-run-button
  '((t :inherit button :height 1.3 :weight bold :box (:line-width 2)))
  "A choice, drawn as a button.")

(defvar-local larder-first-run--status "")

(defun larder-first-run--offered-p (edition profiles)
  "Non-nil if a row with EDITION and PROFILES is offered on this edition."
  (and (or (string= edition "base") (string= edition larder-first-run-edition))
       (or (string= profiles "*")
           (member larder-first-run-profile (split-string profiles " " t)))))

(defun larder-first-run-choices ()
  "Rows of `larder-first-run-choices-file' offered here, as plists."
  (let (rows)
    (with-temp-buffer
      (insert-file-contents larder-first-run-choices-file)
      (dolist (line (split-string (buffer-string) "\n" t))
        (unless (string-prefix-p "#" line)
          (let ((f (split-string line "|")))
            (unless (= (length f) 7) (error "Bad choices row: %s" line))
            (when (larder-first-run--offered-p (nth 1 f) (nth 2 f))
              (push (list :id (nth 0 f) :label (nth 4 f) :plain (nth 5 f)) rows))))))
    (nreverse rows)))

(defun larder-first-run--act (id)
  "Hand choice ID to the dispatcher; return the process.\nIts output lands in the status line."
  (let* ((process-environment
          (append (list (concat "LARDER_PROFILE=" larder-first-run-profile)
                        (concat "LARDER_EDITION=" larder-first-run-edition)
                        (concat "LARDER_CHOICES=" larder-first-run-choices-file))
                  process-environment))
         (shell-buf (current-buffer))
         (out (generate-new-buffer " *larder-action*"))
         (proc (make-process
                :name "larder-action" :buffer out :noquery t
                :command (append (list larder-first-run-open-program)
                                 (when larder-first-run-run '("--run"))
                                 (list id))
                :sentinel
                (lambda (p _event)
                  (unless (process-live-p p)
                    (let ((text (string-trim (with-current-buffer (process-buffer p) (buffer-string)))))
                      (when (buffer-live-p shell-buf)
                        (with-current-buffer shell-buf
                          (setq larder-first-run--status
                                (if (string-empty-p text)
                                    (format "Started (%s)." id)
                                  text))
                          (larder-first-run--render))))
                    (kill-buffer (process-buffer p)))))))
    proc))

(defun larder-first-run--set-theme (which)
  "WHICH is light, dark or default.  Works both ways, whatever came before."
  (mapc #'disable-theme (copy-sequence custom-enabled-themes))
  (pcase which
    ('light (load-theme 'modus-operandi t))
    ('dark  (load-theme 'modus-vivendi t))))

(defun larder-first-run--graphic-p () (display-graphic-p))

(defun larder-first-run--button (label action &rest props)
  (apply #'insert-text-button (format " %s " label)
         'action (lambda (_) (funcall action))
         'follow-link t 'face 'larder-first-run-button props))

(defun larder-first-run--render ()
  (let ((inhibit-read-only t) (pos (point)))
    (erase-buffer)
    (insert (propertize "Welcome" 'face '(:height 2.0 :weight bold)) "\n"
            "Pick one. You can come back to this window whenever you like.\n\n")
    (dolist (c (larder-first-run-choices))
      (let ((id (plist-get c :id)))
        (larder-first-run--button (plist-get c :label)
                                  (lambda () (larder-first-run--act id))
                                  'larder-id id)
        (insert "\n  " (plist-get c :plain) "\n\n")))
    (when (larder-first-run--graphic-p)
      (insert "Colours:  ")
      (larder-first-run--button "Light" (lambda () (larder-first-run--set-theme 'light)))
      (insert "  ")
      (larder-first-run--button "Dark" (lambda () (larder-first-run--set-theme 'dark)))
      (insert "  ")
      (larder-first-run--button "Emacs default" (lambda () (larder-first-run--set-theme 'default)))
      (insert "\n\n"))
    (insert (format "Edition: %s%s.\n%s\n"
                    larder-first-run-profile
                    (if (string= larder-first-run-edition "author") " (author edition)" "")
                    larder-first-run--status))
    (goto-char (min pos (point-max)))))

(define-derived-mode larder-first-run-mode special-mode "Larder"
  "One window of plain choices.  Click, or Tab to a choice and press Return."
  (setq-local mode-line-format nil)
  (setq-local cursor-type nil)
  (setq-local truncate-lines nil))

(defun larder-first-run--kiosk ()
  "One window, no menus, mouse on."
  (when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (delete-other-windows)
  (if (display-graphic-p)
      (set-frame-parameter nil 'fullscreen 'fullboth)
    (xterm-mouse-mode 1)
    (when (and (fboundp 'gpm-mouse-mode) (equal (getenv "TERM") "linux"))
      (gpm-mouse-mode 1))))

;;;###autoload
(defun larder-first-run ()
  "Show the Larder first-run choices in this frame."
  (interactive)
  (switch-to-buffer (get-buffer-create "*Larder*"))
  (larder-first-run-mode)
  (larder-first-run--kiosk)
  (larder-first-run--render)
  (goto-char (point-min))
  (ignore-errors (forward-button 1)))

(provide 'larder-first-run)
;;; larder-first-run.el ends here
