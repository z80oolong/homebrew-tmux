# tmux-eaw-fix -- tmux 2.6 以降において各種問題を修正する野良差分ファイル

## 概要

[tmux][TMUX] は、端末多重化ソフトウェアであり、複数の仮想ウィンドウやペインを同時に操作・表示し、端末セッションの分割や切り替えを可能にします。これにより、単一の端末ウィンドウ内で複数のタスクを効率的に実行できます。

しかし、[tmux 2.6][TMUX] 以降では、以下の問題が報告されています：

- **Unicode の東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字および罫線文字等、[East Asian Width 特性が A（Ambiguous）][EAWA] の文字（以下、[East Asian Ambiguous Character][EAWA]）が、日本語環境で適切な文字幅として扱われず、表示が乱れる。**
- Unicode の絵文字の文字幅が正しく扱われない。
- [tmux][TMUX] のペイン分割におけるボーダーラインの罫線文字の幅が適切に処理されず、画面表示が乱れる。
- **[GitHub 上の HEAD 版の tmux][TMRP] で追加された SIXEL 画像表示において、パレット数が 0 の画像や ORMODE に対応した SIXEL 画像が正常に表示されない、またはプロセスが異常終了する。**

本リポジトリに置かれているファイル ```tmux-x.y-fix.diff```（ここで、```x.y``` は [tmux][TMUX] の安定版のバージョン番号。以下同様）および ```tmux-HEAD-xxxxxxxx-fix.diff```（ここで、```xxxxxxxx``` は [GitHub 上の HEAD 版の tmux][TMRP] の最新のコミット ID 番号。以下同様）は、[tmux 2.6][TMUX] 以降において上記の問題を解決するために以下の修正を加えた野良差分ファイルです。

- [East Asian Ambiguous Character][EAWA] の幅を漢字や全角カナ文字等と同じ全角文字幅で表示するための設定を追加する修正。
- Unicode の絵文字の幅を漢字や全角カナ文字等と同じ全角文字幅で表示するための設定を追加する修正。
- [koie-hidetaka 氏][KOIE] によって作成された、[tmux][TMUX] の[ペイン分割におけるボーダーラインの罫線文字を判別し、適切に描画するためのソースコードの修正][PANE]。
- SIXEL 画像表示において、パレット数が 0 の画像を表示する際に [tmux][TMUX] のプロセス全体が異常終了する問題を修正。
- SIXEL 画像表示において、ORMODE に対応した SIXEL 画像を表示するための修正。
- その他、各種雑多な問題を修正。

なお、本リポジトリは、従来の "**tmux 2.5 以降において East Asian Ambiguous Character を全角文字の幅で表示する**" という名称から、修正範囲が広範にわたることに伴い、 "**tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1]**" と呼称を改めたものです。

## 差分ファイルの適用とインストール

[tmux][TMUX] のソースコードに野良差分ファイルを適用するには、安定版の [tmux][TMUX] には ```tmux-x.y-fix.diff``` を、[GitHub 上の HEAD 版の tmux][TMRP] のソースコードには ```tmux-HEAD-xxxxxxxx-fix.diff``` をそれぞれ適用してください。

安定版の [tmux][TMUX] のソースコードに野良差分ファイルを適用する場合、[tmux][TMUX] のソースコードが置かれているディレクトリで以下のように ```tmux-x.y-fix.diff``` を適用し、```./configure``` および ```make``` コマンドを用いてビルドおよびインストールすることで、上述の修正が施された [tmux][TMUX] が導入されます。

```
  $ patch -p1 < /path/to/diff/tmux-x.y-fix.diff    #（ここで、/path/to/diff は tmux-x.y-fix.diff が置かれたディレクトリのパス名）
  $ ./configure --prefix=/path/to/install ...      # （ここで、/path/to/install は tmux のインストール先。./configure の引数は適宜追加してください。）
  $ make
  # sudo -s
  # make install
```

[GitHub 上の HEAD 版の tmux][TMRP] のソースコードに野良差分ファイルを適用する場合も、ソースコードが置かれているディレクトリで以下のように最新の差分ファイルを適用し、```./configure``` および ```make``` コマンドを用いてビルドおよびインストールすることで、上述の修正が施された [tmux][TMUX] が導入されます。**ただし、[GitHub 上の HEAD 版の tmux][TMRP] のビルドでは、```./configure``` 実行前にシェルスクリプト ```./autogen.sh``` を実行して ```./configure``` を生成する必要があります。**

```
  $ patch -p1 < /path/to/diff/tmux-HEAD-xxxxxxxx-fix.diff    #（ここで、/path/to/diff は tmux-HEAD-xxxxxxxx-fix.diff が置かれたディレクトリのパス名）
  $ sh ./autogen.sh
  $ ./configure --prefix=/path/to/install ...                #（ここで、/path/to/install は tmux のインストール先。./configure の引数は適宜追加してください。）
  $ make
  # sudo -s
  # make install
```

## Homebrew for Linux を用いた差分ファイルの適用とインストール

[Homebrew for Linux][BREW] を導入した端末で野良差分ファイルを適用した [tmux][TMUX] をインストールする場合、**野良差分ファイルを適用した [tmux][TMUX] を導入するための [Homebrew for Linux][BREW] 向け Tap リポジトリ [```z80oolong/tmux```][TAP1] の使用を強く推奨します。**

Tap リポジトリ [```z80oolong/tmux```][TAP1] では、最新の安定版の [tmux][TMUX] および [GitHub 上の最新の HEAD 版の tmux][TMRP] のインストールに加え、旧安定版の [tmux][TMUX] のインストールも可能です。

[```z80oolong/tmux```][TAP1] の詳細な使用方法については、[z80oolong/tmux の README.md][READ] をご覧ください。

## AppImage パッケージを用いたインストール

[tmux][TMUX] のソースコードへの野良差分ファイルの適用およびビルドが困難な環境の方に向けて、**野良差分ファイルを適用した [tmux][TMUX] のビルド済み AppImage パッケージを用意しました。ソースコードからのビルド作業が煩雑な場合は、[tmux][TMUX] の AppImage パッケージの使用を強く推奨します。**

[tmux][TMUX] の AppImage パッケージは、以下の URL で配布されています。詳細な使用方法についても、以下の URL をご覧ください。

- 野良差分ファイル適用 tmux を起動する AppImage ファイルの配布ページ
    - [https://github.com/z80oolong/tmux-eaw-appimage/releases][APPR]

## 各種設定について

本節では、野良差分ファイルを適用後に追加される [tmux][TMUX] のオプションおよび [tmux][TMUX] が参照する環境変数について説明します。

### ```utf8-cjk```

[East Asian Ambiguous Character][EAWA] の文字幅を設定するオプションです。

- **```on``` を指定した場合:** [East Asian Ambiguous Character][EAWA] を全角文字幅で表示します。
- **```off``` を指定した場合:** [East Asian Ambiguous Character][EAWA] を半角文字幅で表示します。

例えば、[East Asian Ambiguous Character][EAWA] を全角文字幅で表示する場合、[tmux][TMUX] の設定ファイル ```~/.tmux.conf``` に以下の設定を追記します。

```
  set-option -g utf8-cjk on
```

なお、```utf8-cjk``` の初期値は以下の通りです：

- 環境変数 ```LC_CTYPE``` が ```ja*```、```ko*```、```zh*``` の場合: ```on``` を設定します。
- それ以外の環境変数 ```LC_CTYPE``` の場合: ```off``` を設定します。

### ```utf8-emoji```

UTF-8 で定義される絵文字の文字幅を設定するオプションです。

- **```on``` を指定した場合:** UTF-8 の絵文字を全角文字幅で表示します。
- **```off``` を指定した場合:** UTF-8 の絵文字を半角文字幅で表示します。

例えば、絵文字を全角文字幅で表示する場合、[tmux][TMUX] の設定ファイル ```~/.tmux.conf``` に以下の設定を追記します。

```
  set-option -g utf8-emoji on
```

なお、```utf8-emoji``` の初期値は以下の通りです：

- 環境変数 ```LC_CTYPE``` が ```ja*```、```ko*```、```zh*``` の場合: ```on``` を設定します。
- それ以外の環境変数 ```LC_CTYPE``` の場合: ```off``` を設定します。

### ```pane-border-ascii```

[tmux][TMUX] のペイン分割で使用する罫線文字に ASCII 文字を使用するかどうかを設定するオプションです。

- **```on``` を指定した場合:** ペイン分割の罫線文字に ASCII 文字を使用します。
- **```off``` を指定した場合:** 環境に応じて UTF-8 の罫線文字、端末が対応する ACS、または ASCII 文字を使用します。

### ```pane-border-acs```

[tmux][TMUX] のペイン分割で罫線の描画に ACS を使用するかどうかを設定するオプションです。

- **```on``` を指定した場合:** ペイン分割の罫線描画に ACS を使用します。
- **```off``` を指定した場合:** 環境に応じて UTF-8 の罫線文字、端末が対応する ACS、または ASCII 文字を使用します。

なお、```pane-border-ascii``` と ```pane-border-acs``` の両方を ```on``` に設定した場合、```pane-border-acs``` が優先されます。

### 環境変数 ```TMUX_ACS```

環境変数 ```TMUX_ACS``` に設定する値に応じて、[tmux][TMUX] のペイン分割における罫線の描画を以下のように制御します：

- **```utf8```, ```utf-8```:** UTF-8 の罫線文字を使用します。
- **```acs```:** ACS を使用します。
- **```ascii```:** ASCII 文字を使用します。

なお、```TMUX_ACS``` の設定は、```pane-border-ascii``` および ```pane-border-acs``` の設定に優先します。

### 環境変数 ```TMUX_CONF```

[tmux 2.6-3.0a][TMUX] では、環境変数 ```TMUX_CONF``` に System-wide で使用する [tmux][TMUX] の設定ファイル ```tmux.conf``` の絶対パスを指定します。

[tmux 3.1][TMUX] 以降では、```TMUX_CONF``` に [tmux][TMUX] が使用する設定ファイル ```tmux.conf``` の絶対パスを、読み込む順にセミコロンで区切って指定します。パスには ```~/``` や環境変数（先頭に ```$```）を使用できます。

```TMUX_CONF``` が指定されない場合、[tmux][TMUX] のコンパイル時に指定されるマクロ ```TMUX_CONF``` の値が使用されます。この環境変数は主に AppImage パッケージで使用されます。

## 謝辞

野良差分ファイルの作成にあたり、[Markus Kuhn 氏][DRMK] が提供する [East Asian Ambiguous Character][EAWA] 対応の ```wcwidth(3)``` 実装（[wcwidth.c][WCWD]）を使用しました。心より感謝申し上げます。

また、[tmux][TMUX] のペイン分割用ボーダーラインの罫線文字の適切な処理に関する修正を提供してくださった [koie-hidetaka 氏][KOIE] に深く感謝いたします。同氏には、他にも野良差分ファイルに関する有益な助言をいただきました。

最後に、[tmux][TMUX] の作者 [Nicholas Marriott 氏][NICM] をはじめ、[tmux の開発コミュニティ][TMUX] および [tmux][TMUX] に関わるすべての皆様に心より感謝いたします。

## 使用条件

本リポジトリの野良差分ファイルは、端末多重化ソフトウェア [tmux][TMUX] に適用する差分ファイルであり、以下の各氏が著作権を有し、[tmux][TMUX] のライセンスと同様である [ISC License][ISCL] に基づいて配布されます：

- [tmux の開発コミュニティ][TMUX]
- [koie-hidetaka 氏][KOIE]
- [Markus Kuhn 氏][DRMK]
- [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL]

使用条件の詳細は、本リポジトリに同梱の ```LICENSE``` ファイルを参照してください。

<!-- 外部リンク一覧 -->

[TMUX]: https://tmux.github.io/  
[EAWA]: http://www.unicode.org/reports/tr11/#Ambiguous  
[TMRP]: https://github.com/tmux/tmux  
[KOIE]: https://github.com/koie  
[PANE]: https://github.com/koie/tmux/commit/ac6c53ffd6c2987a3a4a5807df7fc6cca5d6ce88  
[BREW]: https://linuxbrew.sh/  
[TAP1]: https://github.com/z80oolong/homebrew-tmux  
[READ]: https://github.com/z80oolong/homebrew-tmux/blob/master/README.md  
[APPR]: https://github.com/z80oolong/tmux-eaw-appimage/releases  
[WCWD]: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c  
[DRMK]: http://www.cl.cam.ac.uk/~mgk25/  
[NICM]: https://github.com/nicm  
[ZOOL]: http://zool.jpn.org/  
[ISCL]: https://www.isc.org/downloads/software-support-policy/isc-license/
