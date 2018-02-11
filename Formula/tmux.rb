class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz"
  sha256 "b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8"

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/libevent"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  head do
    url "https://github.com/tmux/tmux.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  if build.head? || build.devel?
    patch do
      url "https://gist.githubusercontent.com/mattn/519542006b9e044e6e529434aae3baa3/raw/fbc8c1ee2e16556ccc12cc21219170a28b7c3843/tmux-HEAD-19afd842-fix.diff"
      sha256 "733a9ffaf437dcc766e53d0ab9f2b74724e5b1a5920595d7c5dc6631922995a9"
    end
  else    
    patch do
      url "https://gist.githubusercontent.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34/raw/cc766299a4ce75ee21b839a74020439fb0d9625b/tmux-2.6-fix.diff"
      sha256 "406fce895df3f0a1dc745ef7cd15784f4114b3841fe8ee7a51b0d456c213b03b"
    end
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
