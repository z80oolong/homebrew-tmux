class TmuxAT23 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "2.3"
  url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
  sha256 "55313e132f0f42de7e020bf6323a1939ee02ab79c48634aa07475db41573852b"
  version tmux_version
  revision 1

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  patch do
    url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
    sha256 "a3736af19d2dcaa50b30fa58d4f3f93dce370988234b1ff4eb9485f7d063b54c"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/libevent@2.2"].opt_lib}"

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
