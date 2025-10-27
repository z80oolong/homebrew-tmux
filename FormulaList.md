# z80oolong/tmux に含まれる Formula 一覧

## 概要

本ドキュメントでは、[Homebrew for Linux][BREW] 向け Tap リポジトリ ```z80oolong/tmux``` に含まれる Formula の一覧を紹介します。

この Tap リポジトリは、[tmux][TMUX] に野良差分ファイルを適用したアプリケーションを提供します。各 Formula の詳細については、```brew info <formula>``` コマンドをご覧ください。

## 告知 (2025/09/21)

2025/09/21 より、[Homebrew for Linux][BREW] 向け Tap リポジトリ ```z80oolong/tmux``` に含まれる Formula について、以下の変更を実施します。

- [tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1] (以下、野良差分ファイル) のページで公開された最新の HEAD 版向け野良差分ファイルを、**その差分ファイルに対応する [GitHub 上の HEAD 版の tmux][TGIT] のコミットに適用したものをインストールするための Formula ```z80oolong/tmux/tmux@{version}-dev``` を新設します。**
    - **この Formula は、```z80oolong/tmux/tmux-current``` による [tmux][TMUX] の最新の HEAD 版の導入時に差分ファイルの適用で不具合が発生する場合に、暫定的に使用するものです。**
    - 従来の ```tmux-head``` は廃止します。
    - なお、2025/09/21 現在、```{version}``` には最新の安定版の仮の次期バージョン番号である 3.6 が指定されます。
- **[最新の安定版および最新の GitHub 上の HEAD 版の tmux][TMUX] に野良差分ファイルを適用したものをインストールするための Formula として、```z80oolong/tmux/tmux-current``` を新設します。**
    - ```z80oolong/tmux/tmux``` は、```z80oolong/tmux/tmux-current``` の alias として存続します。
- **```z80oolong/tmux/tmux-current``` を含め、野良差分ファイルを適用した [tmux][TMUX] を導入する Formula はすべて keg-only としてインストールされます。**
    - これは、```homebrew/core/tmux``` との競合を回避するための措置です。

ご不便をおかけしますが、ご理解とご協力をお願いいたします。

## Formula 一覧

### z80oolong/tmux/tmux

この Formula は、[GitHub 上の最新の HEAD 版の tmux][TGIT] または最新の安定版の [tmux][TMUX] に、野良差分ファイルを適用したものをインストールする ```z80oolong/tmux/tmux-current``` の alias です。

### z80oolong/tmux/tmux-current

この Formula は、[GitHub 上の最新の HEAD 版の tmux][TGIT] または最新の安定版の [tmux][TMUX] に、野良差分ファイルを適用したものをインストールします。

[GitHub 上の HEAD 版の最新コミットの tmux][TGIT] をインストールする場合は、```--HEAD``` オプションを指定してください。

- **注意:**
    - **この Formula は ```homebrew/core/tmux``` と競合するため、keg-only としてインストールされます。**
    - **この Formula によってインストールされた [tmux][TMUX] を使用するには、```brew link --force z80oolong/tmux/tmux-current``` コマンドを実行してください。**

### z80oolong/tmux/tmux@{version}-dev

(注: ```{version}``` には、[tmux][TMUX] の最新安定版の次期バージョンとなりうる仮のバージョン番号が入ります。)

この Formula は、[tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1] のページで公開された最新の HEAD 版向け野良差分ファイルを、その差分ファイルに対応する [GitHub 上の HEAD 版の tmux][TGIT] のコミットに適用したものをインストールします。

たとえば、最新の HEAD 版向け野良差分ファイルが ```tmux-HEAD-xxxxxxxx-fix.diff``` の場合、[GitHub 上の HEAD 版の tmux][TGIT] のコミット ```xxxxxxxx``` がインストールされます。

この Formula によりインストールされる [tmux][TMUX] の具体的なコミットについては、```brew info z80oolong/tmux/tmux@{version}-dev``` コマンドで出力されるメッセージを参照してください。

- **注意:**
    - **この Formula は versioned formula のため、keg-only としてインストールされます。**
    - **この Formula によってインストールされた [tmux][TMUX] を使用するには、```brew link --force z80oolong/tmux/tmux@{version}-dev``` コマンドを実行してください。**
    - **この Formula は、```z80oolong/tmux/tmux-current``` による [tmux][TMUX] の最新の HEAD 版の導入時に差分ファイルの適用で不具合が発生する場合に、暫定的に使用するものです。** 通常の場合は、```z80oolong/tmux/tmux-current``` または ```z80oolong/tmux/tmux``` を使用してください。

### z80oolong/tmux/tmux@{version}

(注: ```{version}``` には、[tmux][TMUX] の各安定版のバージョン番号が入ります。)

この Formula は、安定版の [tmux {version}][TMUX] に、野良差分ファイルを適用したものをインストールします。

- **注意:**
    - **この Formula は versioned formula のため、keg-only としてインストールされます。**
    - **この Formula によってインストールされた [tmux][TMUX] を使用するには、```brew link --force z80oolong/tmux/tmux@{version}``` コマンドを実行してください。**

### z80oolong/tmux/tmux-ncurses@6.2

この Formula は、上述の Formula でインストールされる [tmux][TMUX] に依存する ncurses ライブラリをインストールします。この ncurses ライブラリには、East Asian Ambiguous Character の文字幅を全角文字として扱う修正が施されています。

- **注意:**
    - **この Formula は versioned formula のため、keg-only としてインストールされます。**

### z80oolong/tmux/got

この Formula は、[@gorilla0513 氏][GORI] による [got][GOT_] をインストールするための Formula である ```z80oolong/tmux/got-bin``` の alias です。

### z80oolong/tmux/got-bin

この Formula は、[@gorilla0513 氏][GORI] による [got][GOT_] をインストールします。[got][GOT_] は、tmux のセッション一覧を表示し、セッションへのアタッチや削除を簡単に行うためのツールです。

この Formula は、x86-64 Linux および macOS 向けのビルド済みバイナリファイルをインストールします。**他のアーキテクチャでは、後述の ```z80oolong/tmux/got-src``` を ```brew install z80oolong/tmux/got-src``` コマンドでインストールし、```brew link --force z80oolong/tmux/got-src``` コマンドでリンクしてください。**

- **オプション:**
    - **```--with-tmux```**: ```z80oolong/tmux/tmux``` を同時にインストールします。

### z80oolong/tmux/got-src

この Formula は、[@gorilla0513 氏][GORI] による [got][GOT_] をソースコードからビルドしてインストールします。

- **オプション:**
    - **```--with-tmux```**: ```z80oolong/tmux/tmux``` を同時にインストールします。
- **注意:**
    - **この Formula は ```z80oolong/tmux/got-bin``` と競合するため、keg-only としてインストールされます。**
    - **この Formula によってインストールされた [got][GOT_] を使用するには、```brew link --force z80oolong/tmux/got-src``` コマンドを実行してください。**

### z80oolong/tmux/powerline-status

この Formula は、[tmux][TMUX] のステータスラインを機能的に装飾するツール [powerline][POWE] をインストールします。この Formula では、GitHub 上の HEAD 版の tmux で [powerline][POWE] が正常に動作しない不具合を修正しています。

[GitHub 上の HEAD 版の最新コミットの powerline][POWE] をインストールする場合は、```--HEAD``` オプションを指定してください。

この Formula でインストールされる [powerline][POWE] は、```z80oolong/fonts/umefont``` および ```z80oolong/fonts/vlgothic``` でインストールされる "梅フォント" および "VLゴシックフォント" での動作確認済みです。

- **オプション:**
    - **```--with-tmux```**: ```z80oolong/tmux/tmux``` を同時にインストールします。
- **注意:**
    - この Formula でインストールした [powerline][POWE] を使用するには、設定ファイル ```${HOME}/.tmux.conf``` (または ```${HOME}/.config/tmux/tmux.conf``` など)に以下の設定を記述してください。

```
  # HOMEBREW_PREFIX は、Homebrew for Linux がインストールされているディレクトリに適宜置き換えてください。
  run-shell "HOMEBREW_PREFIX/opt/powerline-status/bin/powerline-daemon -q"
  source HOMEBREW_PREFIX/opt/powerline-status/share/powerline/bindings/tmux/powerline.conf
```

### z80oolong/tmux/powerline-status@{version}

(注: ```{version}``` には、[powerline][POWE] の各安定版のバージョン番号が入ります。)

この Formula は、[tmux][TMUX] のステータスラインを機能的に装飾するツールの安定版 [powerline {version}][POWE] をインストールします。この Formula では、GitHub 上の HEAD 版の tmux で [powerline][POWE] が正常に動作しない不具合を修正しています。

この Formula でインストールされる [powerline][POWE] は、```z80oolong/fonts/umefont``` および ```z80oolong/fonts/vlgothic``` でインストールされる "梅フォント" および "VLゴシックフォント" での動作確認済みです。

- **オプション:**
    - **```--with-tmux```**: ```z80oolong/tmux/tmux``` を同時にインストールします。
- **注意:**
    - **この Formula は versioned formula のため、keg-only としてインストールされます。**
    - **この Formula によってインストールされた [powerline][POWE] を使用するには、```brew link --force z80oolong/tmux/powerline-status@{version}``` コマンドを実行してください。**
    - この Formula でインストールした [powerline][POWE] を使用するには、設定ファイル ```${HOME}/.tmux.conf``` (または ```${HOME}/.config/tmux/tmux.conf``` など)に以下の設定を記述してください。

```
  # HOMEBREW_PREFIX は、Homebrew for Linux がインストールされているディレクトリに適宜置き換えてください。
  run-shell "HOMEBREW_PREFIX/opt/powerline-status/bin/powerline-daemon -q"
  source HOMEBREW_PREFIX/opt/powerline-status/share/powerline/bindings/tmux/powerline.conf
```

### z80oolong/tmux/tpm@3.1.0

この Formula は、[tmux][TMUX] のプラグインを導入および管理するツール [tpm][TPM_] のバージョン 3.1.0 をインストールします。

- **注意:**
    - この Formula でインストールした [tpm][TPM_] を使用するには、設定ファイル ```${HOME}/.tmux.conf``` (または ```${HOME}/.config/tmux/tmux.conf``` など)の末尾に以下の設定を記述してください。

```
  # HOMEBREW_PREFIX は、Homebrew for Linux がインストールされているディレクトリに適宜置き換えてください。
  run-shell -b "HOMEBREW_PREFIX/opt/tpm/libexec/tpm/tpm"
```

<!-- 外部リンク一覧 -->

[BREW]: https://linuxbrew.sh/  
[TMUX]: https://tmux.github.io/  
[TGIT]: https://github.com/tmux/tmux  
[EAWA]: http://www.unicode.org/reports/tr11/#Ambiguous  
[GST1]: https://github.com/z80oolong/tmux-eaw-fix  
[LIBE]: http://libevent.org/  
[DOXY]: http://www.doxygen.org/  
[GLEV]: https://github.com/libevent/libevent  
[GORI]: https://qiita.com/gorilla0513  
[GOT_]: https://github.com/skanehira/got  
[TPM_]: https://github.com/tmux-plugins/tpm  
[POWE]: https://powerline.readthedocs.io/en/latest/#
