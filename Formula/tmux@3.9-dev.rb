class TmuxAT39Dev < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  CURRENT_COMMIT = "95c1c3d7c50795170fd95ec8614bf45fea09faab".freeze

  url "https://github.com/tmux/tmux.git", revision: CURRENT_COMMIT
  version "next-3.9-g#{CURRENT_COMMIT[0..7]}"
  license "ISC"
  revision 17

  keg_only "this is an alternate version of another formula"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "perl" => :build
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
    file "Patches/tmux/tmux-HEAD-#{CURRENT_COMMIT[0..8]}-fix.diff"
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
    ENV["LC_ALL"] = "C"

    system "sh", "autogen.sh"

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
      #{full_name} is a Formula for installing the development version of
      `tmux` based on the HEAD version (commit #{CURRENT_COMMIT[0..7]}) from its git repository.

      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_equal "tmux next-3.9", shell_output("#{bin}/tmux -V").strip
  end
end
