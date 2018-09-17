# z80oolong/tmux に含まれる Formula 一覧

## 概要

本文書では、 [Linuxbrew][BREW] 向け Tap リポジトリ z80oolong/tmux に含まれる Formula 一覧を示します。各 Formula の詳細等については ```brew info <formula>``` コマンドも参照して下さい。

## Formula 一覧

### z80oolong/tmux/tmux

Unicode の規格における東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ずに表示が乱れる問題を修正した [tmux][TMUX] のうち、最新の安定版及び HEAD 版を導入するための Formula です。

即ち、この Formula は、 [tmux][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

### z80oolong/tmux/tmux@2.3

この Formula は、旧安定版である [tmux 2.3][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.3``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.5

この Formula は、旧安定版である [tmux 2.5][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.5``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.6

この Formula は、安定版である [tmux 2.6][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.6``` コマンドを実行する必要があります。

### z80oolong/tmux/tmux@2.7

この Formula は、安定版である [tmux 2.7][TMUX] に、 "[East Asian Ambiguous Character を全角文字の幅で表示する差分ファイル][GST1]" を適用したものを導入します。

**この Formula は、 versioned formula であるため、この Formula によって導入される [tmux][TMUX] は、 keg only で導入されることに留意して下さい。**

この Formula によって導入される [tmux][TMUX] を使用するには、 ```brew link --force z80oolong/tmux/tmux@2.7``` コマンドを実行する必要があります。

### z80oolong/tmux/libevent

上述の Formula によって導入される [tmux][TMUX] に依存するライブラリである [libevent][LIBE] を導入するための Formula です。オリジナルの [libevent][LIBE] の Formula と異なり、安定版の [libevent][LIBE] では、テストプログラムで不具合が発生するため、 [Github 上の libevent][GLEV] を使用しています。

### z80oolong/tmux/doxygen

上述の Formula によって導入される [libevent][LIBE] に依存するライブラリである [doxygen][DOXY] を導入するための Formula です。オリジナルの [doxygen][LIBE] の Formula の安定版において、ソースコードの tarball が取得できない問題を解決しています。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[TMUX]:https://tmux.github.io/
[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[GST1]:https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34
[LIBE]:http://libevent.org/
[DOXY]:http://www.doxygen.org/
[GLEV]:https://github.com/libevent/libevent
