# z80oolong/tmux に含まれる Formula 一覧

## 概要

本文書では、 [Homebrew for Linux][BREW] 向け Tap リポジトリ z80oolong/tmux に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/tmux/tmux

この Formula は、最新の安定版若しくは HEAD 版の [tmux][TMUX] に、 "[tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入するための Formula です。

なお、[tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を回避するために、 ```-V``` オプションを付与してコマンド ```tmux``` を実行した結果を ```tmux master``` とする場合は、オプション ```--with-version-master``` を指定して下さい。

また、 [tmux][TMUX] において East Asian Ambiguous Character の全角文字幅での表示を無効化する場合は、オプション ```--without-utf8-cjk``` を指定して下さい。そして、 [tmux][TMUX] において、画面分割におけるボーダーラインの罫線文字を判別し、適切に描画するための修正を無効化するには、オプション ```--without-pane-border-acs-ascii``` を指定して下さい。

### z80oolong/tmux/tmux@{version}

(注：上記 ```{version}``` には、 [tmux][TMUX] の各バージョン番号が入ります。以下同様。)

この Formula は、安定版の [tmux {version}][TMUX] に、 "[tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1]" を適用したものを導入します。

なお、 [tmux][TMUX] において East Asian Ambiguous Character の全角文字幅での表示を無効化する場合は、オプション ```--without-utf8-cjk``` を指定して下さい。そして、 [tmux][TMUX] において、画面分割におけるボーダーラインの罫線文字を判別し、適切に描画するための修正を無効化するには、オプション ```--without-pane-border-acs-ascii``` を指定して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@{version}``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux-ncurses@6.2

上述の Formula によって導入される [tmux][TMUX] に依存する ncurses ライブラリを導入するための Formula です。オリジナルの ncurses ライブラリに、 East Asian Ambiguous Character の文字幅を全角文字の幅として扱う修正を加えています。

**この Formula は、 versioned formula であるため、この Formula によって導入される ncurses は、 keg only で導入されることに留意して下さい。**

### z80oolong/tmux/got-bin

[@gorilla0513 氏][GORI]による、 tmux の session の一覧を表示し、 attach と削除を容易に行うためのソフトウェアである [got][GOT_] を導入するための Formula です。

なお、この Formula は x86-64 Linux 及び Mac OS 向けの build 済バイナリファイルを導入するものであり、これ以外のアーキテクチャについては、後述する Formula である ```z80oolong/tmux/got-src``` を、 ```brew install z80oolong/tmux/got-src``` コマンドを用いて導入した上で、 ```brew link --force z80oolong/tmux/got-src``` を用いて [got][GOT_] コマンドのリンクを行って下さい。

また、オプション ```--with-tmux``` を指定することにより、 ```z80oolong/tmux/tmux``` を同時に導入することが出来ます。

### z80oolong/tmux/got-src

[@gorilla0513 氏][GORI]による、 [got][GOT_] をソースコードから build することにより、導入するための Formula です。

なお、オプション ```--with-tmux``` を指定することにより、 ```z80oolong/tmux/tmux``` を同時に導入することが出来ます。

**この Formula は、 ```z80oolong/tmux/got-bin``` と競合するため、この Formula によって導入される [got][GOT_] は、 keg only で導入されることに留意して下さい。**

### z80oolong/tmux/got

[@gorilla0513 氏][GORI]による、 [got][GOT_] を導入するための Formula である ```z80oolong/tmux/got-bin``` の alias です。

### z80oolong/tmux/powerline-status

[tmux][TMUX] のステータスラインを機能的に装飾するためのツールである [powerline][POWE] の本体を導入するための Formula です。この Formula で、オリジナルの [powerline][POWE] において発生する HEAD 版上の [tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を修正しています。

なお、この Formula は、デフォルトでは ```z80oolong/tmux/tmux``` に依存しています。 ```z80oolong/tmux/tmux``` の導入を回避するには、オプション ```--without-tmux``` を指定して下さい。

また、 HEAD 版の [tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を修正せずに [powerline][POWE] を導入する場合は、オプション ```--without-fix-powerline``` を指定して下さい。

### z80oolong/tmux/powerline-status@{version}

(注：上記 ```{version}``` には、 [tmux][TMUX] の各バージョン番号が入ります。以下同様。)

[tmux][TMUX] のステータスラインを機能的に装飾するためのツールの安定版である [powerline {version}][POWE] の本体を導入するための Formula です。この Formula で、オリジナルの [powerline][POWE] において発生する HEAD 版上の [tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を修正しています。

なお、この Formula は、デフォルトでは ```z80oolong/tmux/tmux``` に依存しています。 ```z80oolong/tmux/tmux``` の導入を回避するには、オプション ```--without-tmux``` を指定して下さい。

また、 HEAD 版の [tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を修正せずに [powerline][POWE] を導入する場合は、オプション ```--without-fix-powerline``` を指定して下さい。

### z80oolong/tmux/tpm

[tmux][TMUX] のプラグインを導入及び管理するためのアプリケーションである [tpm][TPM_] を導入するための Formula です。

この Formula によって導入された [tpm][TPM_] を使用する際は、**設定ファイル ```${HOME}/.tmux.conf``` の末尾に以下の設定を記述する必要があることに留意して下さい。**

```
# ここに、 HOMEBREW_PREFIX は、 Homebrew for Linux が置かれているディレクトリであり、環境に応じて読み替えて設定すること。
run-shell -b "HOMEBREW_PREFIX/opt/tpm/libexec/tpm/tpm"
```

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[TMUX]:https://tmux.github.io/
[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[GST1]:https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34
[LIBE]:http://libevent.org/
[DOXY]:http://www.doxygen.org/
[GLEV]:https://github.com/libevent/libevent
[GORI]:https://qiita.com/gorilla0513
[GOT_]:https://github.com/skanehira/got
[TPM_]:https://github.com/tmux-plugins/tpm
[POWE]:https://powerline.readthedocs.io/en/latest/#
