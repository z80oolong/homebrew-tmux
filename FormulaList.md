# z80oolong/tmux に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/tmux に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/tmux/tmux

Unicode の規格における東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ずに表示が乱れる問題を修正した [tmux][TMUX] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

即ち、この Formula は、 [tmux][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

なお、[tmux][TMUX] 上で [powerline][POWE] が正常に動作しない不具合を回避するために、 ```-V``` オプションを付与してコマンド ```tmux``` を実行した結果を ```tmux master``` とする場合は、オプション ```--with-version-master``` を指定して下さい。

### z80oolong/tmux/tmux@2.3

この Formula は、旧安定版である [tmux 2.3][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.3``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.4

この Formula は、旧安定版である [tmux 2.4][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.4``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.5

この Formula は、旧安定版である [tmux 2.5][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.5``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.6

この Formula は、旧安定版である [tmux 2.6][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.6``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.7

この Formula は、旧安定版である [tmux 2.7][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.7``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.8

この Formula は、旧安定版である [tmux 2.8][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.8``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.9a

この Formula は、安定版のバグフィックス版である [tmux 2.9a][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.9a``` コマンドを実行する必要があります。

### z80oolong/tmux/libevent@2.2

上述の Formula によって導入される [tmux][TMUX] に依存するライブラリである [libevent][LIBE] を導入するための Formula です。オリジナルの [libevent][LIBE] の Formula と異なり、安定版の [libevent][LIBE] では、テストプログラムで不具合が発生するため、 [Github 上の libevent][GLEV] を使用しています。

なお、この Formula では、デフォルトで [libevent][LIBE] のマニュアル及びドキュメント等が導入されないことに留意して下さい。これらを導入する場合は、オプション ```--with-doxygen``` を使用して下さい。

**この Formula は、 versioned formula であるため、この Formula によって導入される [libevent][LIBE] は、 keg only で導入されることに留意して下さい。**

### z80oolong/tmux/doxygen@1.8

上述の Formula によって導入される [libevent][LIBE] に依存するライブラリである [doxygen][DOXY] を導入するための Formula です。オリジナルの [doxygen][LIBE] の Formula の安定版において、ソースコードの tarball が取得できない問題を解決しています。

**この Formula は、 versioned formula であるため、この Formula によって導入される [doxygen][DOXY] は、 keg only で導入されることに留意して下さい。**

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

### z80oolong/tmux/powerline-fonts

[tmux][TMUX] のステータスラインを機能的に装飾するためのツールである [powerline][POWE] において使用するフォントを導入するための Formula です。

なお、この Formula は、デフォルトでは ```z80oolong/tmux/powerline-status``` に依存しています。 ```z80oolong/tmux/powerline-status``` の導入を回避するには、オプション ```--without-powerline-status``` を指定して下さい。

**なお、この formula によって導入されたフォントは、同時にディレクトリ ```$HOME/.local/share/fonts/powerline-fonts``` 以下にシンボリックリンクが張られることに留意して下さい。**

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
[POWE]:https://powerline.readthedocs.io/en/latest/#
