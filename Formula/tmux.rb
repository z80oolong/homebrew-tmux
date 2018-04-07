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
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-HEAD-b5c0b2ca-fix.diff"
      sha256 "5ffde6a168226783e167bb9755def9c8104a06bd83a0bb22a35b7384e1023f04"
    end
  else    
    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-2.6-fix.diff"
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
