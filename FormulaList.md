# z80oolong/tmux に含まれる Formula 一覧

## 概要

本ドキュメントでは、[Homebrew for Linux][BREW] 向け Tap リポジトリ ```z80oolong/tmux``` に含まれる Formula の一覧を紹介します。各 Formula の詳細は、```brew info <formula>``` コマンドで確認できます。

## 告知 (2025/09/21)

2025/09/21 より、Tap リポジトリ ```z80oolong/tmux``` の Formula に以下の変更を適用します。

1. **Formula ```z80oolong/tmux/tmux@{version}-dev``` の新設**
    - **"[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" の最新版を、[GitHub の HEAD 版][TGIT] の対応するコミットに適用したものを導入します。**
        - 従来の ```tmux-head``` は廃止します。
        - 2025/09/21 時点で、```{version}``` には次期バージョン番号の仮称である ```3.6``` が入ります。
        - **この Formula は、```z80oolong/tmux/tmux-current``` による [tmux][TMUX] の最新の HEAD 版の導入時に差分ファイルの適用で不具合が発生する場合に、暫定的に使用するものです。**
2. **Formula ```z80oolong/tmux/tmux-current``` の新設**
    - **最新の安定版および [GitHub の HEAD 版 tmux][TMUX] に "[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入します。**
    - ```z80oolong/tmux/tmux``` は、```z80oolong/tmux/tmux-current``` の alias として存続します。
3. **keg-only について**
    - ```z80oolong/tmux/tmux-current``` を含む、野良差分ファイルを適用した [tmux][TMUX] の Formula はすべて keg-only として導入されます。
    - これは、```homebrew/core/tmux``` との競合を回避するためです。

ご不便をおかけしますが、ご理解とご協力をお願いいたします。

## Formula 一覧

### z80oolong/tmux/tmux

```z80oolong/tmux/tmux``` は ```z80oolong/tmux/tmux-current``` の alias であり、最新の安定版または [GitHub の HEAD 版 tmux][TMUX] に "[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入します。

### z80oolong/tmux/tmux-current

```z80oolong/tmux/tmux-current``` は、最新の安定版または [GitHub の HEAD 版 tmux][TMUX] に "[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入します。

オプションとして、```--HEAD``` を指定すると HEAD 版の最新コミットが導入され、指定しない場合は最新の安定版が導入されます。

**この Formula は ```homebrew/core/tmux``` と競合するため、keg-only で導入されることに留意してください。** 使用するには ```brew link --force z80oolong/tmux/tmux-current``` を実行してください。

### z80oolong/tmux/tmux@3.6-dev

```z80oolong/tmux/tmux@3.6-dev``` は、"[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" の最新版を [GitHub の HEAD 版 tmux][TGIT] の対応するコミットに適用したものを導入します。**たとえば、最新の野良差分ファイルが ```tmux-HEAD-xxxxxxxx-fix.diff``` の場合、コミット ID ```xxxxxxxx``` のバージョンが導入されます。**

**この Formula は versioned formula のため、keg-only で導入されることに留意してください。** 使用するには ```brew link --force z80oolong/tmux/tmux@3.6-dev``` を実行してください。

**なお、この Formula は ```z80oolong/tmux/tmux-current``` による [tmux][TMUX] の最新の HEAD 版の導入時に差分ファイルの適用で不具合が発生する場合に、暫定的に使用するものです。通常は ```z80oolong/tmux/tmux``` もしくは ```z80oolong/tmux/tmux-current``` を使用してください。**

### z80oolong/tmux/tmux@{version}

```z80oolong/tmux/tmux@{version}``` は、安定版 [tmux {version}][TMUX] に "[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入します。

**この Formula は versioned formula のため、keg-only で導入されることに留意してください。** 使用するには ```brew link --force z80oolong/tmux/tmux@{version}``` を実行してください。

### z80oolong/tmux/tmux-ncurses@6.2

```z80oolong/tmux/tmux-ncurses@6.2``` は、上記 Formula で導入される [tmux][TMUX] に依存する ncurses ライブラリを導入します。East Asian Ambiguous Character の文字幅を全角文字として扱う修正を加えています。

**この Formula は versioned formula のため、keg-only で導入されることに留意してください。**

### z80oolong/tmux/got-bin

```z80oolong/tmux/got-bin``` は、[@gorilla0513 氏][GORI] による [got][GOT_] を導入します。このツールは、tmux のセッション一覧を表示し、attach や削除を簡単に行えます。x86-64 Linux および macOS 向けのビルド済みバイナリを提供します。

オプションとして、```--with-tmux``` を指定すると、```z80oolong/tmux/tmux``` を同時に導入できます。

**その他のアーキテクチャでは、```z80oolong/tmux/got-src``` をインストールし、```brew link --force z80oolong/tmux/got-src``` を実行してください。**

### z80oolong/tmux/got-src

```z80oolong/tmux/got-src``` は、[@gorilla0513 氏][GORI] による [got][GOT_] をソースコードからビルドして導入します。

オプションとして、```--with-tmux``` を指定すると、```z80oolong/tmux/tmux``` を同時に導入できます。

**```z80oolong/tmux/got-bin``` と競合するため、keg-only で導入されることに留意してください。**

### z80oolong/tmux/got

```z80oolong/tmux/got``` は、```z80oolong/tmux/got-bin``` の alias です。

### z80oolong/tmux/powerline-status

```z80oolong/tmux/powerline-status``` は、[tmux][TMUX] のステータスラインを装飾する [powerline][POWE] を導入します。HEAD 版 [tmux][TMUX] での動作不具合を修正しています。

**なお、この Formula で導入される powerline は、 ```z80oolong/fonts/umefont``` および ```z80oolong/fonts/vlgothic``` で導入される "梅フォント" 及び "VLゴシックフォント" で動作確認しています。**

オプションとして、```--with-tmux``` を指定すると、```z80oolong/tmux/tmux``` を同時に導入できます。

**使用するには、```${HOME}/.tmux.conf```（または ```${HOME}/.config/tmux/tmux.conf```）に以下の設定を記述してください。**

```
  # HOMEBREW_PREFIX は環境に応じて設定してください。
  run-shell "HOMEBREW_PREFIX/opt/powerline-status/bin/powerline-daemon -q"
  source HOMEBREW_PREFIX/opt/powerline-status/share/powerline/bindings/tmux/powerline.conf
```

### z80oolong/tmux/powerline-status@{version}

```z80oolong/tmux/powerline-status@{version}``` は、安定版 [powerline {version}][POWE] を導入します。HEAD 版 [tmux][TMUX] での動作不具合を修正しています。

**なお、この Formula で導入される powerline は、 ```z80oolong/fonts/umefont``` および ```z80oolong/fonts/vlgothic``` で導入される "梅フォント" 及び "VLゴシックフォント" で動作確認しています。**

オプションとして、```--with-tmux``` を指定すると、```z80oolong/tmux/tmux``` を同時に導入できます。

**使用するには、```${HOME}/.tmux.conf```（または ```${HOME}/.config/tmux/tmux.conf```）に以下の設定を記述してください。**

```
  # HOMEBREW_PREFIX は環境に応じて設定してください。
  run-shell "HOMEBREW_PREFIX/opt/powerline-status/bin/powerline-daemon -q"
  source HOMEBREW_PREFIX/opt/powerline-status/share/powerline/bindings/tmux/powerline.conf
```

**この Formula は versioned formula のため、keg-only で導入されることに留意してください。** 使用するには ```brew link --force z80oolong/tmux/powerline-status@{version}``` を実行してください。

### z80oolong/tmux/tpm

```z80oolong/tmux/tpm``` は、[tmux][TMUX] のプラグインを管理する [tpm][TPM_] を導入します。

**使用するには、```${HOME}/.tmux.conf```（または ```${HOME}/.config/tmux/tmux.conf```）の末尾に以下の設定を記述してください。**

```
  # HOMEBREW_PREFIX は環境に応じて設定してください。
  run-shell -b "HOMEBREW_PREFIX/opt/tpm/libexec/tpm/tpm"
```

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[TMUX]:https://tmux.github.io/
[TGIT]:https://github.com/tmux/tmux
[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[GST1]:https://github.com/z80oolong/tmux-eaw-fix
[LIBE]:http://libevent.org/
[DOXY]:http://www.doxygen.org/
[GLEV]:https://github.com/libevent/libevent
[GORI]:https://qiita.com/gorilla0513
[GOT_]:https://github.com/skanehira/got
[TPM_]:https://github.com/tmux-plugins/tpm
[POWE]:https://powerline.readthedocs.io/en/latest/#
