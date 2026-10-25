class TmuxAT38 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/3.8/tmux-3.8.tar.gz"
  sha256 "e79c699c7e949dccd0a4a125e17b8d1261e311b16979dbc8eb34542f3966d82e"
  license "ISC"
  revision 16

  keg_only "this is an alternate version of another formula"

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

  patch :p1 do
    file "Patches/tmux/tmux-3.8-fix.diff"
    type :unofficial
  end

  def install
    old_curses_f = Formula["ncurses"]
    new_curses_f = Formula["z80oolong/tmux/tmux-ncurses@6.5"]
    replace_list = {
      old_curses_f.lib.to_s     => new_curses_f.lib.to_s,
      old_curses_f.opt_lib.to_s => new_curses_f.opt_lib.to_s,
    }

    if (rpaths = ENV.fetch("HOMEBREW_RPATH_PATHS", false))
      ENV["HOMEBREW_RPATH_PATHS"] = (rpaths.split(":").map do |rpath|
        replace_list.fetch(rpath, rpath)
      end).join(":")
    end
    ENV.append "LDFLAGS", "-lresolv"

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

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_equal "tmux #{version}", shell_output("#{bin}/tmux -V").strip
  end
end
