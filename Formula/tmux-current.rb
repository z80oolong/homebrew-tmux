class TmuxCurrent < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"
  revision 16

  CURRENT_VERSION = "3.8".freeze
  CURRENT_COMMIT  = "95c1c3d7c50795170fd95ec8614bf45fea09faab".freeze

  stable do
    url "https://github.com/tmux/tmux/releases/download/#{CURRENT_VERSION}/tmux-#{CURRENT_VERSION}.tar.gz"
    sha256 "e79c699c7e949dccd0a4a125e17b8d1261e311b16979dbc8eb34542f3966d82e"

    patch :p1 do
      file "Patches/tmux/tmux-#{CURRENT_VERSION}-fix.diff"
      type :unofficial
    end
  end

  head do
    url "https://github.com/tmux/tmux.git", revision: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "perl" => :build

    patch :p1 do
      file "Patches/tmux/tmux-HEAD-#{CURRENT_COMMIT[0..8]}-fix.diff"
      type :unofficial
    end
  end

  keg_only "this formula conflicts with `homebrew/core/tmux`"

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

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    ver = build.head? ? "next-3.8" : version
    assert_equal "tmux #{ver}", shell_output("#{bin}/tmux -V").strip
  end
end
