#!/usr/bin/env ruby

if $PROGRAM_NAME == __FILE__
  puts DATA.gets(nil)
  exit 0
end

class TmuxCurrent < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 15

  stable do
    url "https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz"
    sha256 "16216bd0877170dfcc64157085ba9013610b12b082548c7c9542cc0103198951"

    patch :p1, Formula["z80oolong/tmux/tmux@3.5a"].diff_data
  end

  head do
    url "https://github.com/tmux/tmux.git", revision: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "perl" => :build

    patch :p1, Formula["z80oolong/tmux/tmux@3.6-dev"].diff_data
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
    ver = build.head? ? "next-3.6" : version
    assert_equal "tmux #{ver}", shell_output("#{bin}/tmux -V").strip
  end
end

module EnvExtend
  def replace_rpath(**replace_list)
    replace_list = replace_list.each_with_object({}) do |(old, new), result|
      result[old.to_s] = new.to_s
    end

    if (rpaths = fetch("HOMEBREW_RPATH_PATHS", false))
      self["HOMEBREW_RPATH_PATHS"] = (rpaths.split(":").map do |rpath|
        replace_list.fetch(rpath, rpath)
      end).join(":")
    end
  end
end

ENV.extend(EnvExtend)
