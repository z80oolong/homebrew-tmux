require "#{Tap.fetch("z80oolong/tmux").path}/lib/extend.rb"
ENV.extend(EnvExtend)

class TmuxCurrent < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 15

  stable do
    url "https://github.com/tmux/tmux/releases/download/3.6b/tmux-3.6b.tar.gz"
    sha256 "390759d25fdba016887ec982b808927e637070fd7d03a8021f8ef3102b9ae3c7"

    patch :p1, Formula["z80oolong/tmux/tmux@3.6b"].diff_data
  end

  head do
    url "https://github.com/tmux/tmux.git", revision: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "perl" => :build

    patch :p1, Formula["z80oolong/tmux/tmux@3.7-dev"].diff_data
  end

  keg_only "this formula conflicts with 'homebrew/core/tmux'"

  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "z80oolong/tmux/tmux-ncurses@6.5"

  on_macos do
    depends_on "utf8proc"
  end

  on_linux do
    depends_on "glibc"
    depends_on "utf8proc" => :optional
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    old_curses_f = Formula["ncurses"]
    new_curses_f = Formula["z80oolong/tmux/tmux-ncurses@6.5"]

    ENV.replace_rpath old_curses_f.lib     => new_curses_f.lib,
                      old_curses_f.opt_lib => new_curses_f.opt_lib
    ENV.append "LDFLAGS", "-lresolv"
    ENV["LC_ALL"] = "C"

    system "sh", "autogen.sh" if build.head?

    args =  std_configure_args
    args << "--sysconfdir=#{etc}"
    args << "--with-TERM=tmux-256color"
    args << "--enable-sixel"
    args << "--enable-utf8proc" if build.with?("utf8proc") || OS.mac?

    system "./configure", *args

    system "make"
    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def post_install
    return unless OS.linux?

    ohai "Installing locale data for {ja_JP, zh_*, ko_*, ...}.UTF-8"

    localedef = Formula["glibc"].opt_bin/"localedef"
    %w[ja_JP zh_CN zh_HK zh_SG zh_TW ko_KR en_US].each do |lang|
      system localedef, "-i", lang, "-f", "UTF-8", "#{lang}.UTF-8"
    end
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    ver = build.head? ? "next-3.7" : version
    assert_equal "tmux #{ver}", shell_output("#{bin}/tmux -V").strip
  end
end
