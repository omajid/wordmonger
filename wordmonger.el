;;; wordmonger.el --- highlight inappropriate words for review -*- lexical-binding: t -*-

;;; Copyright (C) 2019 Omair Majid

;; Author: Omair Majid <omair.majid@gmail.com>
;; URL: https://github.com/omajid/wordmonger
;; Keywords: wp files
;; Version: 0.1.20190404
;; Package-Requires: ((emacs "24"))

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Check buffer for use of appropriate words

;;; Code:

(defgroup wordmonger nil
  "Group for `wordmonger'."
  :group 'text)

(defface wordmonger-warning-face
  '((t (:inherit warning :background "red")))
  "Face for warnings"
  :group 'wordmonger)

(defcustom wordmonger-word-alist
  '()
  "A list of (WORD . REPLACEMENT).

Each pair indicates a term that should not appear in text unless
it's as REPLACEMENT.

For example: (setq wordmonger-word-alist '((\"foo\" . \"my foo bar\"))."
  :type '(alist :key-type string :value-type string)
  :group 'wordmonger)

(defun wordmonger--write-config (file)
  "Write a config to FILE based on current mode configuration."
  (with-temp-file file
    (insert "[DEFAULT]\n")
    (mapc (lambda (elt) (insert (format "%s=%s\n" (car elt) (cdr elt))))
          wordmonger-word-alist)))

(defun wordmonger--initialize-config ()
  "Create an initialize a configuration file."
  (let ((file (make-temp-file "wordmonger-config")))
    (wordmonger--write-config file)
    file))

(defun wordmonger--check ()
  "Check current buffer for containing special words."
  (remove-overlays nil nil 'wordmonger-overlay t)
  (let* ((configfile (wordmonger--initialize-config))
         (checker (expand-file-name
                   "wordmonger-check"
                   (file-name-directory (symbol-file 'wordmonger--check))))
         (output (shell-command-to-string (concat checker " " configfile " "  (buffer-file-name))))
         (lines (split-string output "\n")))
    (mapc (lambda (line)
            (when (string-match "\\([[:digit:]]+\\): \"\\([^\"]+\\)\" -> \"\\([^\"]+\\)\"" line)
              (let* ((pos-start (+ 1 (string-to-number (match-string 1 line))))
                     (word (match-string 2 line))
                     (pos-end (+ pos-start (string-bytes word)))
                     (replacement (match-string 3 line))
                     (overlay (make-overlay pos-start pos-end nil t)))
                (overlay-put overlay 'wordmonger-overlay t)
                (overlay-put overlay 'face 'wordmonger-warning-face)
                (overlay-put overlay 'help-echo (format "Should be '%s'" replacement)))))
          lines)
    (delete-file configfile)))

(defun wordmonger--clear ()
  "Clear all cruft from the buffer."
  (remove-overlays nil nil 'wordmonger-overlay t))

(define-minor-mode wordmonger-mode
  "Minor mode for checking technical terms"
  :init-value nil
  :lighther "ಠ_ರೃ"
  :keymap nil
  :group 'wordmonger
  (if wordmonger-mode
      (progn
        (wordmonger--check)
        (add-hook 'after-save-hook #'wordmonger--check nil t))
    (remove-hook 'after-save-hook #'wordmonger--check t)
    (wordmonger--clear)))

(provide 'wordmonger)
;;; wordmonger.el ends here
