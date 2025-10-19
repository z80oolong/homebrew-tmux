# z80oolong/tmux -- tmux に野良差分ファイルを適用するための Formula 群

## 概要

[Homebrew for Linux][BREW] は、Linux ディストリビューション向けのソースコードベースのパッケージ管理システムです。これを利用することで、ソフトウェアのソースコードからのビルドおよびインストールが簡単かつ効率的に行えます。

[tmux][TMUX] は、端末多重化ソフトウェアであり、複数の仮想ウィンドウやペインを同時に操作・表示し、端末セッションの分割や切り替えを可能にします。これにより、単一の端末ウィンドウ内で複数のタスクを効率的に実行できます。

しかし、[tmux 2.6][TMUX] 以降では、以下の問題が報告されています：

- Unicode の東アジア圏の各種文字のうち、いわゆる "◎" や "★" 等の記号文字及び罫線文字等の、いわゆる [East_Asian_Width 特性が A（Ambiguous）][EAWA] の文字（以下、[East Asian Ambiguous Character][EAWA]）が、日本語環境で適切な文字幅として扱われず、表示が乱れる。
- Unicode の絵文字の文字幅が正しく扱われない。
- [tmux][TMUX] のペイン分割におけるボーダーラインの罫線文字の幅が適切に処理されず、画面表示が乱れる。
- [tmux][TMUX] の HEAD 版で追加された SIXEL 画像表示において、パレット数が 0 の画像や ORMODE に対応した SIXEL 画像が正常に表示されない、またはプロセスが異常終了する。

本 [Homebrew for Linux][BREW] 向け Tap リポジトリは、[tmux 2.6 以降の各種問題を修正する野良差分ファイル][GST1] を適用した [tmux][TMUX] を導入するためのものです。また、[powerline][POWE] や [got][GOT_] など、[tmux][TMUX] の利用に有用なツールの Formula も提供しています。

## 使用方法

1. 以下のリソースを参考に、[Homebrew for Linux][BREW] を端末にインストールします：
    - [thermes 氏][THER] による「[Linuxbrew のススメ][THBR]」
    - [Homebrew for Linux 公式ページ][BREW]
2. 本リポジトリの Formula を以下のようにインストールします：
    ```
      $ brew tap z80oolong/tmux
      $ brew install <formula>
    ```

または、一時的な方法として、以下のように URL を直接指定してインストール可能です：

```
  $ brew install https://raw.githubusercontent.com/z80oolong/homebrew-tmux/master/Formula/<formula>.rb
```

利用可能な Formula の一覧および詳細は、本リポジトリに同梱の `FormulaList.md` を参照してください。

## 詳細情報

本リポジトリおよび [Homebrew for Linux][BREW] の使用方法の詳細は、以下のコマンドやリソースを参照してください：

- `brew help` コマンド
- `man brew` コマンド
- [Homebrew for Linux 公式ページ][BREW]

## 謝辞

[tmux][TMUX] の差分ファイル作成にあたり、[Markus Kuhn 氏][DRMK] が提供する [East Asian Ambiguous Character][EAWA] 対応の `wcwidth(3)` 実装（[wcwidth.c][WCWD]）を使用しました。心より感謝申し上げます。

また、[tmux][TMUX] のペイン分割用ボーダーラインの罫線文字の適切な処理に関する修正を提供してくださった [koie-hidetaka 氏][KOIE] に深く感謝いたします。同氏には、他にも本差分ファイルに関する有益な助言をいただきました。

さらに、以下のツールの開発者に感謝申し上げます：
- [tmux][TMUX] のセッション選択を容易にする [got][GOT_] の開発者、[@gorilla0513 氏][GORI]
- [tmux][TMUX] のステータスラインを装飾する [powerline][POWE] の開発コミュニティ、特に Fabrizio Schiavi 氏

[Homebrew for Linux][BREW] の導入には、[Homebrew for Linux 公式ページ][BREW] および [thermes 氏][THER] の「[Linuxbrew のススメ][THBR]」を参考にしました。開発コミュニティおよび [thermes 氏][THER] に感謝申し上げます。

最後に、[tmux][TMUX] の作者 [Nicholas Marriott 氏][NICM] をはじめ、[tmux][TMUX] および [Homebrew for Linux][BREW] に関わるすべての皆様に心より感謝いたします。

## 使用条件

本リポジトリは、[Homebrew for Linux][BREW] の Tap リポジトリとして、[Homebrew for Linux 開発コミュニティ][BREW] および [Z.OOL. (mailto:zool@zool.jpn.org)][ZOOL] が著作権を有し、[BSD 2-Clause License][BSD2] に基づいて配布されます。詳細は、本リポジトリに同梱の `LICENSE` ファイルを参照してください。

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
