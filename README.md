# z80oolong/tmux -- tmux に野良差分ファイルを適用するための Formula 群

## 概要

[Homebrew for Linux][BREW] とは、Linux の各ディストリビューションにおけるソースコードの取得及びビルドに基づいたパッケージ管理システムです。 [Homebrew for Linux][BREW] の使用により、ソースコードからのビルドに基づいたソフトウェアの導入を単純かつ容易に行うことが出来ます。

また、 [tmux][TMUX] とは、 terminal session を効果的に操作できる端末多重化ソフトウェアです。 [tmux][TMUX] の使用により、複数の仮想 window や pane を同時に表示し、それらの間を切り替えたり terminal session を分割することが可能となります。そして、これにより単一の terminal window 内で複数の task を同時に実行することが可能となります。

しかし、 [tmux][TMUX] において、Unicode の規格における東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等、 [East_Asian_Width 特性の値が A (Ambiguous) となる文字][EAWA] (以下、 [East Asian Ambiguous Character][EAWA]) が、日本語環境で文字幅を適切に扱うことが出来ずに表示が乱れる問題等、幾つかの問題が発生しています。

この [Homebrew for Linux][BREW] 向け Tap リポジトリは、前述の各種問題を修正するための差分ファイルである "[tmux 2.6 以降において各種問題を修正する野良差分ファイル][GST1]" をソースコードに適用した [tmux][TMUX] を導入するためのリポジトリです。

また、 [powerline][POWE] や [got][GOT_] 等、本リポジトリで導入される [tmux][TMUX] を使用する際に有用となるツールを導入するための Formula も同梱しています。

## 使用法

まず最初に、以下に示す Qiita の投稿及び Web ページの記述に基づいて、手元の端末に [Homebrew for Linux][BREW] を構築します。

- [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" の投稿
- [Homebrew for Linux の公式ページ][BREW]

そして、本リポジトリに含まれる Formula を以下のようにインストールします。

```
 $ brew tap z80oolong/tmux
 $ brew install <formula>
```

なお、一時的な手法ですが、以下のようにして URL を直接指定してインストールすることも出来ます。

```
 $ brew install https://raw.githubusercontent.com/z80oolong/homebrew-tmux/master/Formula/<formula>.rb
```

なお、本リポジトリに含まれる Formula の一覧及びその詳細については、本リポジトリに同梱する ```FormulaList.md``` を参照して下さい。

## その他詳細について

その他、本リポジトリ及び [Homebrew for Linux][BREW] の使用についての詳細は ```brew help``` コマンド及び  ```man brew``` コマンドの内容、若しくは [Homebrew for Linux の公式ページ][BREW]を御覧下さい。

## 謝辞

まず最初に、 [tmux][TMUX] に関する差分ファイルを作成するに当たっては、下記の URL にある、 Markus Kuhn 氏が作成した [East Asian Ambiguous Character][EAWA] の扱いを考慮した wcwidth(3) 関数の実装を使用しました。 [Markus Kuhn][DRMK] 氏には心より感謝いたします。

[http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c][WCWD]

また、本差分ファイルについて、 [tmux][TMUX] の画面分割の為のボーダーラインの罫線文字について判別と適切な描画を行う為の修正を作成して頂いた [koie-hidetaka 氏][KOIE]に心より感謝致します。 [koie-hidetaka 氏][KOIE]におきましては、他にも本差分ファイルに関して有益な指摘も幾つか頂きました。

そして、本リポジトリで導入される [tmux][TMUX] を使用するにあたって非常に有用であるツールであり：

- 端末上で [tmux][TMUX] のセッション選択を容易にするツールである [got][GOT_] を作成された [@gorilla0513 氏][GORI]に心より感謝致します。
- [tmux][TMUX] のステータスラインを機能的に装飾するツールである Fabrizio Schiavi 氏を始めとする [powerline][POWE] の開発コミュニティの各氏に心より感謝致します。

そして、[Homebrew for Linux][BREW] の導入に関しては、 [Homebrew for Linux の公式ページ][BREW] の他、 [thermes 氏][THER]による "[Linuxbrew のススメ][THBR]" 及び [Homebrew for Linux][BREW] 関連の各種資料を参考にしました。 [Homebrew for Linux の開発コミュニティ][BREW]及び[thermes 氏][THER]を始めとする各氏に心より感謝致します。

そして最後に、 [tmux][TMUX] の作者である [Nicholas Marriott 氏][NICM]を初め、 [tmux][TMUX] に関わる全ての皆様及び、 [Homebrew for Linux][BREW] に関わる全ての皆様に心より感謝致します。

## 使用条件

本リポジトリは、 [Homebrew for Linux][BREW] の Tap リポジトリの一つとして、 [Homebrew for Linux の開発コミュニティ][BREW]及び [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL] が著作権を有し、[Homebrew for Linux][BREW] のライセンスと同様である [BSD 2-Clause License][BSD2] に基づいて配布されるものとします。詳細については、本リポジトリに同梱する ```LICENSE``` を参照して下さい。

<!-- 外部リンク一覧 -->

[BREW]:https://linuxbrew.sh/
[TMUX]:https://tmux.github.io/
[EAWA]:http://www.unicode.org/reports/tr11/#Ambiguous
[GST1]:https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34
[THER]:https://qiita.com/thermes
[THBR]:https://qiita.com/thermes/items/926b478ff6e3758ecfea
[WALT]:https://github.com/waltarix
[WCWD]:http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
[DRMK]:http://www.cl.cam.ac.uk/~mgk25/
[NICM]:https://github.com/nicm
[GORI]:https://qiita.com/gorilla0513
[KOIE]:https://github.com/koie
[GOT_]:https://github.com/skanehira/got
[POWE]:https://powerline.readthedocs.io/en/latest/#
[BSD2]:https://opensource.org/licenses/BSD-2-Clause
[ZOOL]:http://zool.jpn.org/
