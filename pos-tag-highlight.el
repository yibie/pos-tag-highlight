;;; pos-tag-highlight.el --- Highlight prepositions and verbs using POS tagging -*- lexical-binding: t; -*-

;; Author: Yibie <yibie@outlook.com>
;; Version: 1.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: grammar, highlighting, POS tagging, tools
;; URL: https://github.com/yibie/pos-tag-highlight

;;; Commentary:

;; This package highlights prepositions and verbs in the current buffer or a selected region
;; using spaCy for POS tagging. It provides commands to apply or remove highlighting
;; and binds them to convenient key combinations.

;;; Code:

(defgroup pos-tag-highlight nil
  "Highlight prepositions and verbs using POS tagging."
  :prefix "pos-tag-highlight-"
  :group 'tools
  :link '(url-link :tag "GitHub" "https://github.com/yibie/pos-tag-highlight"))

(defcustom pos-tag-highlight-python-command "python"
  "Command to run Python. Change this to the full path if needed."
  :type 'string
  :group 'pos-tag-highlight)

(defcustom pos-tag-highlight-python-script-path
  (expand-file-name "pos-tagger.py" (file-name-directory #$))
  "Path to the Python POS tagger script."
  :type 'file
  :group 'pos-tag-highlight)

(defcustom pos-tag-highlight-face 'bold
  "Face for highlighting prepositions and verbs."
  :type 'face
  :group 'pos-tag-highlight)

;;;###autoload
(defun pos-tag-highlight-pos-tag-text (text)
  "Use spaCy to perform POS tagging on TEXT."
  (let ((coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8))
    (let ((result
           (with-temp-buffer
             (insert text)
             (message "Calling Python script with text: %s" (truncate-string-to-width text 100 nil nil "..."))
             (let* ((error-file (make-temp-file "pos-tag-error"))
                    (exit-code
                     (call-process-region (point-min) (point-max)
                                          pos-tag-highlight-python-command
                                          nil (list (current-buffer) error-file) nil
                                          pos-tag-highlight-python-script-path)))
               (message "Python script exit code: %s" exit-code)
               (if (= exit-code 0)
                   (buffer-string)
                 (with-temp-buffer
                   (insert-file-contents error-file)
                   (delete-file error-file)
                   (error "Python script failed with exit code %d: %s" exit-code (buffer-string))))))))
      (message "POS tagging result: %s" (truncate-string-to-width result 100 nil nil "..."))
      result)))

;;;###autoload
(defun pos-tag-highlight-buffer ()
  "Highlight prepositions and verbs in the current buffer using POS tagging."
  (interactive)
  (pos-tag-highlight--region (point-min) (point-max)))

;;;###autoload
(defun pos-tag-highlight-region (begin end)
  "Highlight prepositions and verbs in the specified region using POS tagging."
  (interactive "r")
  (pos-tag-highlight--region begin end))

(defun pos-tag-highlight--region (begin end)
  "Internal function to highlight prepositions and verbs between BEGIN and END."
  (let* ((text (buffer-substring-no-properties begin end))
         (tagged-text (pos-tag-highlight-pos-tag-text text))
         (words (split-string tagged-text)))
    (message "Tagged text: %s" tagged-text)
    (save-excursion
      (goto-char begin)
      (dolist (word words)
        (let* ((parts (split-string word "_"))
               (word-text (car parts))
               (tag (cadr parts)))
          (when (or (string= tag "ADP")  ; Preposition in spaCy
                    (string-prefix-p "VERB" tag)) ; Verb in spaCy
            (message "Highlighting word: %s" word-text)
            (when (search-forward word-text end t)
              (let ((word-end (point))
                    (word-start (- (point) (length word-text))))
                (put-text-property word-start word-end
                                   'font-lock-face pos-tag-highlight-face)))))))))

;;;###autoload
(defun pos-tag-highlight-remove-all-properties ()
  "Remove all text properties from the current buffer."
  (interactive)
  (remove-text-properties (point-min) (point-max) '(font-lock-face nil)))

;; Key Bindings
(defvar pos-tag-highlight-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c p h b") 'pos-tag-highlight-highlight-buffer)
    (define-key map (kbd "C-c p h r") 'pos-tag-highlight-highlight-region)
    (define-key map (kbd "C-c p h c") 'pos-tag-highlight-remove-all-properties)
    map)
  "Keymap for `pos-tag-highlight-mode'.")

;;;###autoload
(define-minor-mode pos-tag-highlight-mode
  "Minor mode to highlight prepositions and verbs using POS tagging."
  :lighter " PT"
  :keymap pos-tag-highlight-mode-map
  :group 'pos-tag-highlight)

(provide 'pos-tag-highlight)

;;; pos-tag-highlight.el ends here