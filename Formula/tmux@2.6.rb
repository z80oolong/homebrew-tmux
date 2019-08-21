class TmuxAT26 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "2.6"
  url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
  sha256 "b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8"
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
    sha256 "23ae0a6667f70f270325ac3b2f50bdc92b7c137b99233fad10cd871ef2689e9b"
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
