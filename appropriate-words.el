;;; appropriate-words.el --- highlight inappropriate words  -*- lexical-binding: t -*-

;;; Copyright (C) 2019 Omair Majid

;; Author: Omair Majid <omair.majid@gmail.com>
;; URL: https://github.com/omajid/appropriate-words/
;; Keywords:
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

(defgroup appropriate-words nil
  "Group for `appropriate-words'."
  :group nil)

(defface appropriate-words-warning-face
  '((t (:inherit warning :background "red")))
  "Face for warnings"
  :group 'appropriate-words)

(defun appropriate-words--check ()
  "Check current buffer for containing special words."
  (message "checking words")
  (remove-overlays nil nil 'appropriate-words-overlay t)
  (let* ((checker (expand-file-name
                   "check-usage-of-words"
                   (file-name-directory (symbol-file 'appropriate-words--check))))
         (output (shell-command-to-string (concat checker " " (buffer-file-name))))
         (lines (split-string output "\n")))
    (mapc (lambda (line)
            (when (string-match "\\([[:digit:]]+\\): \"\\([^\"]+\\)\" -> \"\\([^\"]+\\)\"" line)
              (let* ((pos-start (+ 1 (string-to-number (match-string 1 line))))
                     (word (match-string 2 line))
                     (pos-end (+ pos-start (string-bytes word)))
                     (replacement (match-string 3 line))
                     (overlay (make-overlay pos-start pos-end nil t)))
                (overlay-put overlay 'appropriate-words-overlay t)
                (overlay-put overlay 'face 'appropriate-words-warning-face)
                (overlay-put overlay 'help-echo (format "Should be '%s'" replacement)))))
          lines)))

(defun appropriate-words--clear ()
  "Clear all cruft from the buffer."
  (remove-overlays nil nil 'appropriate-words-overlay t))

(define-minor-mode appropriate-words-mode
  "Minor mode for checking appropriate-words"
  :init-value nil
  :lighther "ಠ_ರೃ"
  :keymap nil
  (if appropriate-words-mode
      (progn
        (appropriate-words--check)
        (add-hook 'after-save-hook #'appropriate-words--check nil t))
    (remove-hook 'after-save-hook #'appropriate-words--check t)
    (appropriate-words--clear)))

(provide 'appropriate-words)
;;; appropriate-words.el ends here
