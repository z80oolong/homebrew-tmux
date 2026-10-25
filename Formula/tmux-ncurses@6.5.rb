class TmuxNcursesAT65 < Formula
  desc "Text-based UI library"
  homepage "https://invisible-island.net/ncurses/announce.html"
  url "https://ftpmirror.gnu.org/gnu/gnu/ncurses/ncurses-6.5.tar.gz"
  mirror "https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz"
  mirror "ftp://ftp.invisible-island.net/ncurses/ncurses-6.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.5.tar.gz"
  sha256 "136d91bc269a9a5785e5f9e980bc76ab57428f604ce3e5a5a90cebc767971cc6"
  license "MIT"

  keg_only "this is an alternate version of another formula"

  depends_on "pkgconf" => :build
  on_linux do
    depends_on "glibc" => :build
    depends_on "gpatch" => :build
  end

  patch :p1 do
    file "Patches/tmux-ncurses/tmux-ncurses-6.5-fix.diff"
    type :unofficial
  end

  def install
    ENV.append "CFLAGS", "-std=gnu17"
    ENV["LC_ALL"] = "C"

    # Workaround for
    # macOS: mkdir: /usr/lib/pkgconfig:/opt/homebrew/Library/Homebrew/os/mac/pkgconfig/12: Operation not permitted
    # Linux: configure: error: expected a pathname, not ""
    (lib/"pkgconfig").mkpath

    args =  std_configure_args
    args << "--prefix=#{prefix}"
    args << "--enable-pc-files"
    args << "--with-default-terminfo-dir=#{share}/terminfo"
    args << "--with-pkg-config-libdir=#{lib}/pkgconfig"
    args << "--enable-sigwinch"
    args << "--enable-symlinks"
    args << "--enable-widec"
    args << "--with-shared"
    args << "--with-cxx-shared"
    args << "--with-gpm=no"
    if OS.linux?
      terminfodirs =  []
      terminfodirs << "#{opt_share}/terminfo"
      terminfodirs << "#{share}/terminfo"
      terminfodirs << "/etc/terminfo"
      terminfodirs << "/lib/terminfo"
      terminfodirs << "/usr/share/terminfo"

      args << "--with-terminfo-dirs=#{terminfodirs.join(":")}"
      args << "--without-ada"
    end

    system "./configure", *args
    system "make", "install"
    make_libncurses_symlinks

    # Avoid hardcoding Cellar paths in client software.
    inreplace bin/"ncursesw6-config", prefix, opt_prefix
    pkgshare.install "test"
    (pkgshare/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.major.to_s

    %w[form menu ncurses panel ncurses++].each do |name|
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}")
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}", major)
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink shared_library("libncurses") => shared_library("libcurses")
    on_linux do
      # libtermcap and libtinfo are provided by ncurses and have the
      # same api. Help some older packages to find these dependencies.
      # https://bugs.centos.org/view.php?id=11423
      # https://bugs.launchpad.net/ubuntu/+source/ncurses/+bug/259139
      lib.install_symlink "libncurses.so" => "libtermcap.so"
      lib.install_symlink "libncurses.so" => "libtinfo.so"
    end

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"
    (lib/"pkgconfig").install_symlink "formw.pc" => "form.pc"
    (lib/"pkgconfig").install_symlink "menuw.pc" => "menu.pc"
    (lib/"pkgconfig").install_symlink "panelw.pc" => "panel.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink "ncursesw" => "ncurses"
    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    refute_match prefix.to_s, shell_output("#{bin}/ncursesw6-config --prefix")
    refute_match share.to_s, shell_output("#{bin}/ncursesw6-config --terminfo-dirs")

    ENV["TERM"] = "xterm"

    system pkgshare/"test/configure", "--prefix=#{testpath}",
                                      "--with-curses-dir=#{prefix}"
    system "make", "install"
    system testpath/"bin/ncurses-examples"
  end
end
