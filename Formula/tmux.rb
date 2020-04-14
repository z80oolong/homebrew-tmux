class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  revision 4

  stable do
    tmux_version = "3.0a"
    url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
    sha256 "4ad1df28b4afa969e59c08061b45082fdc49ff512f30fc8e43217d7b0e5f8db9"
    version tmux_version

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
      sha256 "d223ddc4d7621416ae0f8ac874155bc963a16365ada9598eff74129141ad7948"
    end
  end

  devel do
    tmux_version = "3.1-rc4"
    url "https://github.com/tmux/tmux/releases/download/3.1/tmux-#{tmux_version}.tar.gz"
    sha256 "11c4d9431567835004a132c412c238856fa0cd02e8e4d2932ab70d222ad97b56"
    version tmux_version

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
      sha256 "f9efcbdcd7048b549141ca06be435dbc142d99fefc06464995aea650f778d480"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/tmux-eaw-fix/master/tmux-HEAD-b117c3b8-fix.diff"
      sha256 "0770822d8661bc85f83af6ba41c0961d03c155af0ea6ce326aebbdce34a405a2"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "bison" => :build
  end

  depends_on "z80oolong/tmux/tmux-libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  option "with-version-master", "In head build, set the version of tmux as `master`."
  option "without-utf8-cjk", "Build without using East asian Ambiguous Width Character in tmux."
  option "without-pane-border-acs-ascii", "Build without using ACS ASCII as pane border in tmux."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_lib}"

    if build.head? && build.with?("version-master") then
      inreplace "configure.ac" do |s|
        s.gsub!(/AC_INIT\(\[tmux\],[^)]*\)/, "AC_INIT([tmux], master)")
      end
    end

    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK" if build.without?("utf8-cjk")
    ENV.append "CPPFLAGS", "-DNO_USE_PANE_BORDER_ACS_ASCII" if build.without?("pane-border-acs-ascii")

    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if build.with?("utf8proc")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
