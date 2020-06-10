class TmuxNcursesAT62 < Formula
  desc "Text-based UI library for tmux."
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.2.tar.gz"
  sha256 "30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d"
  version "6.2"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gpatch" => :build unless OS.mac?

  diff_file = (Tap.fetch("z80oolong/tmux").path/"diff/tmux-ncurses@6.2-fix.diff")
  patch :p1, diff_file.open.gets(nil)

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--with-shared",
                          "--with-gpm=no",
                          *("--without-ada" unless OS.mac?)
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]
    minor = version.to_s.split(".")[1]

    %w[form menu ncurses panel].each do |name|
      if OS.mac?
        (lib/"lib#{name}w.#{major}.#{minor}.dylib").rename(lib/"lib#{name}w-eaw.#{major}.#{minor}.dylib")
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}w-eaw.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}w.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}-eaw.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}.#{major}.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.#{minor}.dylib" => "lib#{name}w.#{major}.dylib"
      else
        (lib/"lib#{name}w.so.#{major}.#{minor}").rename(lib/"lib#{name}w-eaw.so.#{major}.#{minor}")
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}-eaw.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w-eaw.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}.so.#{major}"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w.so.#{major}"
      end
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    if OS.mac?
      lib.install_symlink "libncurses.dylib" => "libcurses.dylib"
    else
      lib.install_symlink "libncurses.so" => "libcurses.so"
      lib.install_symlink "libncurses.so" => "libtermcap.so"
      lib.install_symlink "libncurses.so" => "libtinfo.so"
    end

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"
    (lib/"pkgconfig").install_symlink "formw.pc" => "form.pc"
    (lib/"pkgconfig").install_symlink "menuw.pc" => "menu.pc"
    (lib/"pkgconfig").install_symlink "panelw.pc" => "panel.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
