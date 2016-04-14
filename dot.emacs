;; -*- mode: emacs-lisp; -*-

;;
;; 日本語の設定
;;
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(setenv "LANG" "ja_JP.UTF-8")

;;
;; Input method の設定 (Mac 以外は mozc 利用)
;;
(if (not (string-match "apple" (emacs-version)))
    (progn (load-library "mozc")
	   (setq default-input-method "japanese-mozc"))
  (progn (setq default-input-method "MacOSX")
	 (mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ")))

;;
;; タブ設定
;;
(setq-default tab-with 8)
(setq-default indent-tabs-mode nil)

;;
;; 表示設定
;;
;(setq display-time-string-forms
;      '((substring year -2) "年" month "月" day "日(" dayname ") "
;	24-hours "時" minutes "分"))
(if (or (eq window-system 'x) (eq window-system nil))
    (setq display-time-format "%m月%d日 (%a) %H:%M")
    (setq display-time-format "%Y/%m/%d(%a) %H:%M"))
(setq display-time-load-average nil)
(setq display-time-mail-string "")
(display-time)
(line-number-mode t)
(column-number-mode t)

;; Tool bar を表示しない
(tool-bar-mode 0)

;;
;; パッケージ設定 (MELPA)
;;
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
;(setq-default package-check-signature nil)
(package-initialize)

;;
;; Org-mode + MobileOrg
;;
(setq org-directory "~/Dropbox/org")
(setq org-mobile-directory "~/Dropbox/アプリ/MobileOrg")
(setq org-mobile-files
      (list "~/Dropbox/org/notes.org"
            "~/Dropbox/org/todo.org"
            "~/Dropbox/org/iphone.org"
            ))
(setq org-mobile-inbox-for-pull "~/Dropbox/org/iphone.org")

;;
;; ido-mode
;;
(ido-mode 1)
(ido-everywhere 1)
;;
;; M-x コマンドの補完
;;
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; 入力メソッドの ON / OFF でカーソル色を変更
(set-cursor-color "#0060ff")
(add-hook 'input-method-activate-hook '(lambda () (set-cursor-color "red")))
(add-hook 'input-method-inactivate-hook '(lambda () (set-cursor-color "#0060ff")))

;;
;; MacOS X の ls が --dired をサポートしないので、homebrew の coreutils をインストール
;;
(let ((gls "/usr/local/bin/gls"))
     (if (file-exists-p gls) (setq insert-directory-program gls)))

;;
;; フォント設定(Mac)
;;
(if (eq window-system 'ns)
    ;; フォント設定(Mac)
    (progn (set-default-font "Monaco-12")
	   (set-face-font 'variable-pitch "Monaco-12")
	   (set-fontset-font (frame-parameter nil 'font)
			     'japanese-jisx0208
			     '("Hiragino Kaku Gothic ProN" . "iso10646-1"))))

;;
;; フォント設定(Linux)
;;
;;(if (eq window-system 'x)
;;  (progn (set-default-font "Inconsolata-11")
;;	 (set-face-font 'variable-pitch "Inconsolata-11")
;;	 (set-fontset-font (frame-parameter nil 'font)
;;			   'japanese-jisx0208
;;			   '("M+ 1m light" . "unicode-bmp"))))

;;
;; フォント設定(Linux) Ricty を使用する
;;   http://save.sys.t.u-tokyo.ac.jp/~yusa/fonts/ricty.html
(if (eq window-system 'x)
  (progn (set-default-font "Ricty-11")))

;;(if (eq window-system 'x)
;;    (progn (set-face-attribute 'default nil
;;			       :family "Ricty"
;;			       :height 120)))

;; デフォルトのフレーム
(setq default-frame-alist
      (append (list
	       '(width . 80)
	       '(height . 43)
	       )
	      default-frame-alist))

;; カレントディレクトリをホームディレクトリに
(cd "~/")

(add-to-list 'load-path "~/Dropbox/Emacs/yasnippet/")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/Dropbox/Emacs/yasnippets-rails/rails-snippets")
(yas/load-directory "~/Dropbox/Emacs/yasnippet/snippets/")

;;
;; PHP script edit mode.
;;
;; (See Drupal mode: http://drupal.org/node/59868)
;; (Emacs with on-line help: http://drupal.org/node/249296)
;; (Html Mode Deluxe: (http://www.emacswiki.org/emacs/HtmlModeDeluxe)
;;
(require 'php-mode)
;(setq php-mode-force-pear t)
(setq php-manual-url "http://www.php.net/manual/ja/")
(setq php-mode-coding-style 'psr2)
(add-hook 'php-mode-hook '(lambda ()
	  'php-enable-psr2-coding-style
	  (subword-mode 1)))

;(add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))

;;
;; CakePHP 2 edit mode
;;
(defun cake2-mode ()
  "CakePHP Version2 php-mode."
  (interactive)
  (php-mode)
  (message "CakePHP2 mode activated.")
  (set 'tab-width 8)
  (set 'c-basic-offset 8)
  (set 'indent-tabs-mode t)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields and values
  ; More Drupal-specific customizations here
)

;;
;; Drupal Mode
;;
(defun drupal-mode ()
  "Drupal php-mode."
  (interactive)
  (php-mode)
  (message "Drupal mode activated.")
  (set 'tab-width 2)
  (set 'c-basic-offset 2)
  (set 'indent-tabs-mode nil)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-cont-nonempty 'c-lineup-math) ; for DBTNG fields and values
  ; More Drupal-specific customizations here
)
(add-to-list 'auto-mode-alist '("\\.inc$" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.module$" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.install$" . drupal-mode))

;;
;; web-mode
;;
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tpl$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp$" . web-mode))
(add-hook 'web-mode-hook
          (lambda()
            (setq web-mode-markup-indent-offset 2
                  web-mode-css-indent-offset 4
                  web-mode-code-indent-offset 4
                  indent-tabs-mode nil)))

