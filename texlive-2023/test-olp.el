;; -*- lexical-binding: t; -*-
(setq org-persist-directory (expand-file-name "./persist"))

(require 'org-persist)
(require 'org-latex-preview)
(require 'org)
(require 'latex)

(require 'elp)
(load-file "../etrace.el")
(setq etrace-output-file (expand-file-name "./etrace.json"))

(elp-reset-all)
(elp-instrument-package "org-latex-preview")
(elp-instrument-package "org-persist-")
(elp-instrument-function 'garbage-collect)

(etrace-clear)

(add-hook 'org-latex-preview-process-finish-functions
          (defun my/org-latex-preview-benchmark-finish (&rest _)
            (setq my-org-latex-preview-benchmark-time
                  (- (float-time) my-org-latex-preview-benchmark-time))
            (run-at-time 0.1 nil #'etrace-write)
            (message "Run took: %.4f seconds" my-org-latex-preview-benchmark-time)))

(defun my-org-latex-preview-precompile-first ()
  (interactive)
  (or org-latex-preview--preamble-content
      (org-latex-preview--get-preamble)))

(defvar my-org-latex-preview-benchmark-time 0.0)

(defun my-org-latex-preview-benchmark ()
  "Run benchmark"
  (interactive)
  ;; (save-excursion
  ;;   (goto-char (point-min))
  ;;   (org-latex-preview-clear-cache))
  ;; (or org-latex-preview--preamble-content
  ;;     (org-latex-preview--get-preamble))
  (elp-reset-all)
  (garbage-collect)
  (sit-for 0.1)
  (etrace-clear)
  (setq my-org-latex-preview-benchmark-time (float-time))
  (org-latex-preview '(16)))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c b") #'my-org-latex-preview-benchmark)
  (define-key org-mode-map (kbd "C-c p") #'my-org-latex-preview-precompile-first))
