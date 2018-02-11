class TmuxAT25 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz"
  sha256 "ae135ec37c1bf6b7750a84e3a35e93d91033a806943e034521c8af51b12d95df"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/libevent"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  patch do
    url "https://gist.githubusercontent.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/365d948925bbd1be513c8ae9fb34ff85b499681c/tmux-2.5-fix.diff"
    sha256 "4fc930a37c0ef199342a1d6450628d0cdf92c32cda5daa2428f494f73f0b3377"
  end

  def install
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
