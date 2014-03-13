;;------------------------------------------------------------------------------
;; el-get
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")

(el-get 'sync '(
                ace-jump-mode
                anything
                auto-complete
                cperl-mode
                color-theme
                color-theme-solarized
                ;; emacs-w3m
                evil
                git-commit-mode
                git-emacs
                git-blame
                grep-edit
                helm
                js2-mode
                ;; magit
                markdown-mode
                ;; mmm-mode
                ;; multi-web-mode
                multiple-cursors
                perl-completion
                perlcritic
                popwin
                quickrun
                recentf-ext
                redo+
                ;; ruby-electric
                slime
                simpleclip
                sql-complete
                sql-completion
                sql-indent
                tabbar
                thing-opt
                yaml-mode
                yasnippet
                zenburn-theme
                ))


;;------------------------------------------------------------------------------
;; package.el
;;------------------------------------------------------------------------------
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


;; C-hに1文字削除を割り当てる
(global-set-key (kbd "C-h") 'delete-backward-char)

;; ステータスバー？に時間を表示
;; (display-time)

;; ラインナンバー表示
(line-number-mode 1)

;; コラムナンバー表示
(column-number-mode 1)

(setq echo-keystrokes 0.1)

(setq backup-inhibited t)

;; ツールバーをなんとかする
(tool-bar-mode 0)
(cond
 (window-system (tool-bar-mode -1))
 (t (menu-bar-mode -1)))

;; スクロールバーをなんとかする
(toggle-scroll-bar nil)

;; オートセーブファイルを削除
(setq delete-auto-save-files t)

;; バックアップファイル作成
(setq make-backup-files nil)

;; オートセーブファイル作成
(setq auto-save-default nil)

;; インデントにタブを使わない
(setq-default tab-width 4 indent-tabs-mode nil)

;; タイトルバーに文言を表示
;; (setq frame-title-format (format "%%f - Emacs@%s" (system-name))) ; フルパス
(setq frame-title-format (format "(ノ｀Д´)ノ彡┻━┻  (;´Д｀)ﾊｧﾊｧ  ♪～(￣ε￣；)  (｡･_･｡)  (´ﾟдﾟ｀)ｴｰ  (〃∇〃)  ( ﾟдﾟ)ﾎｽｨ…" ))

;; 行番号表示
;; (global-linum-mode t)
;; 行番号フォーマット
(if (display-graphic-p)
  (setq linum-format "%4d")
  (setq linum-format "%4d "))

;; 括弧の範囲内を強調表示
(show-paren-mode 1)
(setq show-paren-delay 0)
;; (setq show-paren-style 'expression)
;; 括弧の範囲色
;; (set-face-background 'show-paren-match-face "#c99")

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; ;; highlight-chars.el
;; (require 'highlight-chars)
;; (hc-toggle-highlight-tabs 1)

(setq comment-style 'multi-line)

(transient-mark-mode 1)

;; 複数ウィンドウを開かないようにする
(setq ns-pop-up-frames nil)

;; クリップボードを使う
(setq x-select-enable-clipboard t)

;; コメント行でのC-mでの改行時にコメントを行を引っ張る
(setq indent-line-function 'indent-relative-maybe)
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-m" 'indent-new-comment-line)

;; grep-edit
(require 'grep-edit)

;; Emacs-Lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda()
             (rainbow-delimiters-mode)))


;;------------------------------------------------------------------------------
;; theme
;;------------------------------------------------------------------------------
;; (load-theme 'wombat t)
(load-theme 'zenburn t)

;;------------------------------------------------------------------------------
;; C-aでインデントを飛ばした行頭に移動
;;------------------------------------------------------------------------------
(defun beginning-of-indented-line (current-point)
  (interactive "d")
  (if (string-match
       "^[ \t]+$"
       (save-excursion
         (buffer-substring-no-properties
          (progn (beginning-of-line) (point))
          current-point)))
      (begging-of-line)
    (back-to-indentation)))

(defun beginning-of-visual-indented-line (current-point)
  (interactive "d")
  (let ((vhead-pos (save-excursion (progn (beginning-of-visual-line) (point))))
        (head-pos (save-excursion (progn (beginning-of-line) (point)))))
    (cond
     ((eq vhead-pos head-pos)
      (if (string-match
           "^[ \t]+$"
           (buffer-substring-no-properties vhead-pos current-point))
          (beginning-of-visual-line)
        (back-to-indentation)))
     ((eq vhead-pos current-point)
      (backward-char)
      (beginning-of-visual-indented-line (point)))
     (t (beginning-of-visual-line)))))

(global-set-key "\C-a" 'beginning-of-visual-indented-line)
(global-set-key "\C-e" 'end-of-visual-line)

;;------------------------------------------------------------------------------
;; pathの引き継ぎ
;;------------------------------------------------------------------------------
;; ~/.zshrcを利用する
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))
;; (setf exec-path nil) ; exec-pathの内容をリセットしたい場合

;; Emacsだけでやるパターン
;; (let ((path-str
;;        (replace-regexp-in-string
;;         "\n+$" "" (shell-command-to-string "echo $PATH"))))
;;   (setenv "PATH" path-str)
;;   (setq exec-path (nconc (split-string path-str ":") exec-path)))

;; (if window-system
;;     (exec-path-from-shell-initialize))


;;------------------------------------------------------------------------------
;; emacsclient
;; シェルから現在のEmacsにアクセスする
;;------------------------------------------------------------------------------
(server-start)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(setq server-socket-dir (format "/private/tmp/emacs%d" (user-uid)))

;;------------------------------------------------------------------------------
;; dictionary
;;------------------------------------------------------------------------------
(defun dictionary ()
  "dictionary.app"
  (interactive)
  (let ((editable (not buffer-read-only))
        (pt (save-excursion (mouse-set-point last-nonmenu-event)))
        beg end)
    (if (and mark-active
             (<= (region-beginning) pt) (<= pt (region-end)))
        (setq beg (region-beginning)
              end (region-end))
      (save-excursion
        (goto-char pt)
        (setq end (progn (forward-word) (point)))
        (setq beg (progn (backward-word) (point)))
        ))
    (browse-url
     (concat "dict:///"
             (url-hexify-string (buffer-substring-no-properties beg end))))))
(define-key global-map (kbd "C-c d") 'dictionary)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;------------------------------------------------------------------------------
;; font
;;------------------------------------------------------------------------------
(if window-system
    (progn
      (create-fontset-from-ascii-font "Ricty-13:weight=normal:slant=normal" nil "ricty")
      (set-fontset-font "fontset-ricty"
                        'unicode
                        (font-spec :family "Ricty" :size 13)
                        nil
                        'append)
      (add-to-list 'default-frame-alist '(font . "fontset-ricty"))))


;;------------------------------------------------------------------------------
;; white space
;;------------------------------------------------------------------------------
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
(set-face-background 'whitespace-tab "DarkSlateGray")

;;------------------------------------------------------------------------------
;; mouse
;;------------------------------------------------------------------------------
(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key "\C-xm" 'xterm-mouse-mode)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))




;;------------------------------------------------------------------------------
;; モジュール
;;------------------------------------------------------------------------------

;;------------------------------------------------------------------------------
;; auto-complete.el
;; M-x auto-install-from-emacswiki auto-complete.el
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete")
(require 'auto-complete)
(global-auto-complete-mode t)
(setq ac-disable-faces nil)             ; コメント記述中も有効にする
(setq ac-use-menu-map t)                ; 補完メニュー表示時専用のキー操作を有効にする

;;------------------------------------------------------------------------------
;; css-mode
;;------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist (cons "\\.\\(css\\|less\\)\\'" 'css-mode))
(add-hook 'css-mode-hook
          '(lambda()
             (git-gutter+-mode)))

;;------------------------------------------------------------------------------
;; evil
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; flymake-mode
;;------------------------------------------------------------------------------
;; (setq flymake-log-level 3)

;;------------------------------------------------------------------------------
;; git-commit-mode
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/git-commit-mode")

;;------------------------------------------------------------------------------
;; gitconfig-mode
;;------------------------------------------------------------------------------

;;------------------------------------------------------------------------------
;; gitignore-mode
;;------------------------------------------------------------------------------

;;------------------------------------------------------------------------------
;; gitrebase-mode
;;------------------------------------------------------------------------------

;;------------------------------------------------------------------------------
;; magit
;;------------------------------------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/el-get/magit")
;; (require 'magit)

;; set key bind for 'magit-status' at "M-m"

;; Removing Highlights on Diff mode
; Don't really like the highlights on diff mode... Made it optional using:
;; (defcustom magit-use-highlights nil
;;   "Use highlights in diff buffer."
;;   :group 'magit
;;   :type 'boolean)
;; (set-face-background 'magit-item-highlight "#202020")
;; (eval-after-load 'magit
;;   '(progn
;;      (set-face-background 'magit-item-highlight "#202020")
;;      ))


;;------------------------------------------------------------------------------
;; git-gutter+
;;------------------------------------------------------------------------------


;;------------------------------------------------------------------------------
;; helm
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/helm")
(require 'helm-config)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x f") 'helm-recentf)

;;------------------------------------------------------------------------------
;; helm-project
;;------------------------------------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/el-get/helm-project")
;; (require 'helm-project)
;; (global-set-key (kbd "C-c C-f") 'helm-project)

;;------------------------------------------------------------------------------
;; javascript.el
;;------------------------------------------------------------------------------
(autoload 'javascript-mode "javascript" nil t)
(setq js-indent-level 4)
(add-hook 'javascript-mode-hook         ;なんだかうまくいかない
          '(lambda ()
             (git-gutter+-mode)))

;;------------------------------------------------------------------------------
;; js2-mode
;;------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist (cons  "\\.\\(js\\|as\\|json\\|jsn\\|jsx\\)\\'" 'js2-mode))
(add-hook 'js2-mode-hook
          '(lambda ()
             (git-gutter+-mode)))

;;------------------------------------------------------------------------------
;; markdown-mode
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;------------------------------------------------------------------------------
;; migemo
;;------------------------------------------------------------------------------
;; git clone https://github.com/emacs-jp/migemo.git ~/.emacs.d/recipes/migemo
(add-to-list 'load-path "~/.emacs.d/recipes/migemo")
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

;;------------------------------------------------------------------------------
;; multiple cursors
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/multiple-cursors")
(require 'multiple-cursors)
;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;;------------------------------------------------------------------------------
;; perl tidy
;;------------------------------------------------------------------------------
; sudo aptitude install perltidy
(defun perltidy-region ()
  "Run perltidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "perltidy -q" nil t)))

(defun perltidy-defun ()
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun) (perltidy-region)))

;; バッファ全体にperltidyをかける
(defun perltidy-whole-buffer ()
  "Run perltidy on the whole current buffer."
  (interactive)
  (mark-whole-buffer)
  (perltidy-region)
  (save-buffer))

;;------------------------------------------------------------------------------
;; perlcritic
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/perlcritic")
(require 'perlcritic)

(defun perl-tidy-critic ()
  "Run perltidy and perlcritic at same time."
  (interactive)
  (perltidy-whole-buffer)
  (perlcritic))

;;------------------------------------------------------------------------------
;; perl-completion
;;------------------------------------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/recipes/perl-completion")
(require 'perl-completion)

;;------------------------------------------------------------------------------
;; CPerl mode
;;------------------------------------------------------------------------------
(load-library "cperl-mode")
(add-to-list 'auto-mode-alist '("\\.[Pp][LlMm][Cc]?$" . cperl-mode))
(while (let ((orig (rassoc 'perl-mode auto-mode-alist)))
         (if orig (setcdr orig 'cperl-mode))))
(while (let ((orig (rassoc 'perl-mode interpreter-mode-alist)))
         (if orig (setcdr orig 'cperl-mode))))
(dolist (interpreter '("perl" "perl5" "miniperl" "pugs"))
  (unless (assoc interpreter interpreter-mode-alist)
    (add-to-list 'interpreter-mode-alist (cons interpreter 'cperl-mode))))

(add-hook 'cperl-mode-hook
          '(lambda()
             (cperl-set-style "PerlStvle")))
(defalias 'perl-mode 'cperl-mode)

(autoload 'cperl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(setq cperl-indent-level 4
      cperl-continued-statement-offset 4
      cperl-close-paren-offset -4
      cperl-label-offset 4
      cperl-highlight-variables-indiscriminately t
      cperl-indent-parens-as-block t
      cperl-indent-subs-specially nil
      cperl-tab-always-indent nil
      cperl-indent-region-fix-constructs 1
      cperl-font-lock t)

(add-to-list 'auto-mode-alist (cons  "\\.\\(pl\\|pm\\|psgi\\|t\\)\\'" 'cperl-mode))

;; バッファ内でperlを実行
(defun perl-eval (beg end)
  "Run selected region as Perl code"
  (interactive "r")
  (shell-command-on-region beg end "perl")
  ; feeds the region to perl on STDIN
  )
(global-set-key "\M-\C-p" 'perl-eval)

(defvar ac-source-my-perl-completion
  '((candidates . plcmp-ac-make-cands)))
(defun my-cperl-mode-hook ()
  (interactive)
  (setq indent-tabs-mode nil)
  (setq tab-width nil)
  (cperl-set-style "PerlStyle")
  (setq cperl-tab-always-indent t)      ; always indent current line
  (define-key cperl-mode-map "\M-p" 'cperl-perldoc)
  (define-key cperl-mode-map "\C-ct" 'perltidy-whole-buffer)
  (define-key cperl-mode-map "\C-c\C-c\C-c" 'perlcritic)
  ;; (flymake-mode)
  (git-gutter+-mode)
  (perl-completion-mode t)
  (add-to-list 'ac-sources' 'ac-source-my-perl-completion)
  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|TODO\\|BUG\\)" 1 font-lock-warning-face t)))
  )
(add-hook 'cperl-mode-hook 'my-cperl-mode-hook)

;; plcmp-cmd-show-docでperlbrewを参照する
(eval-after-load "woman"
  '(add-to-list 'woman-manpath "/Users/syanuma/perl5/perlbrew/perls/perl-5.16.3/man"))

;;------------------------------------------------------------------------------
;; rainbow-delimiters
;;------------------------------------------------------------------------------

;;------------------------------------------------------------------------------
;; recentf-ext
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/recentf-ext")
(setq recentf-max-saved-items 500)
(setq recentf-exculde '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)

;;------------------------------------------------------------------------------
;; reqdo+.el
;; 「やり直し」を改善する
;; M-x install-elisp-from-emacswiki redo+.el
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/redo+")
(require 'redo+)
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "C-M-/") 'redo)
(global-set-key (kbd "M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 60000)
(setq undo-strong-limit 900000)

;;------------------------------------------------------------------------------
;; smartparens
;;------------------------------------------------------------------------------
(package-initialize)
(smartparens-global-mode t)

;;------------------------------------------------------------------------------
;; sql-mode
;;------------------------------------------------------------------------------
;; mysqlのキーワードにハイライトを当てる
(add-hook 'sql-mode-hook 'sql-highlight-mysql-keywords)


;;------------------------------------------------------------------------------
;; tabbar
;;------------------------------------------------------------------------------
(tabbar-mode t)
(if tabbar-mode
    (progn
      (define-key global-map (kbd "C-c n") 'tabbar-forward-tab)
      (define-key global-map (kbd "C-c p") 'tabbar-backward-tab)
      ))

;;------------------------------------------------------------------------------
;; thing-opt.el
;;------------------------------------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/el-get/thing-opt")
;; (require 'thing-opt)
;; (define-thing-commands)

;; ;; テキストオブジェクトのように...
;; ;; カット
;; (key-chord-define-global "dw" 'kill-word*)   ; 単語
;; (key-chord-define-global "ds" 'kill-sexp*)   ; s式
;; (key-chord-define-global "dq" 'kill-string)  ; 文字列表示
;; (key-chord-define-global "dl" 'kill-up-list) ; リスト表示
;; ;; delete なのか kill なのか
;; (key-chord-define-global "kw" 'kill-word*)
;; (key-chord-define-global "ks" 'kill-sexp*)
;; (key-chord-define-global "kq" 'kill-string)
;; (key-chord-define-global "kl" 'kill-up-list)
;; ;; コピー
;; (key-chord-define-global "yw" 'copy-word)
;; (key-chord-define-global "ys" 'copy-sexp)
;; (key-chord-define-global "yq" 'copy-string)
;; (key-chord-define-global "yl" 'copy-up-list)
;; ;; リージョン選択
;; (key-chord-define-global "vw" 'mark-word*)
;; (key-chord-define-global "vs" 'mark-sexp*)
;; (key-chord-define-global "vq" 'mark-string)
;; (key-chord-define-global "vl" 'mark-up-list)

;;------------------------------------------------------------------------------
;; tt-mode
;;------------------------------------------------------------------------------
;; (require 'tt-mode)
;; (add-to-list 'auto-mode-alist (cons  "\\.\\(tt\\)\\'" 'tt-mode))
;; (add-hook 'tt-mode-hook
;;           '(lambda()
;;              (git-gutter+-mode)))

;;------------------------------------------------------------------------------
;; yaml-mode
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/yaml-mode")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (git-gutter+-mode)))


;;------------------------------------------------------------------------------
;; yasnippet.el
;; 略語から定型文を入力する
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/el-get/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
(setq yas/snippet-dirs "~/.emacs.d/el-get/yasnippet/snippets")
(setq yas/prompt-functions '(yas/dropdown-prompt yas/ido-prompt yas/completing-prompt))

;;------------------------------------------------------------------------------
;; web-mode
;;------------------------------------------------------------------------------
(add-to-list 'auto-mode-alist (cons "\\.\\(html\\|htm\\|tt\\)\\'" 'web-mode))
;; (define-key web-mode-map "\C-cm" 'web-mode-tag-match)
(add-hook 'web-mode-hook
          '(lambda()
             (git-gutter+-mode)))




;;------------------------------------------------------------------------------
;; key bind
;;------------------------------------------------------------------------------
(define-key global-map (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "M-?") 'help-for-help)
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)
(define-key global-map (kbd "C-o") 'ace-jump-mode)
(define-key global-map (kbd "M-C-g") 'grep)
(define-key global-map (kbd "C-x l") 'goto-line)
;; (define-key global-map (kbd "C-x l") 'linum-mode)
(define-key global-map (kbd "C-x C-l") 'toggle-truncate-lines)
(define-key global-map (kbd "M-x") 'helm-M-x)
(define-key global-map (kbd "M-m") 'magit-status)
(define-key global-map (kbd "C-c b") 'magit-blame-mode)
(define-key global-map (kbd "C-i") 'indent-for-tab-command) ;yasnippetをよぶと上書きされるため
(define-key global-map (kbd "M-q") 'keyboard-quit)

