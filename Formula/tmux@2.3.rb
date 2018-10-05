class TmuxAT23 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz"
  sha256 "55313e132f0f42de7e020bf6323a1939ee02ab79c48634aa07475db41573852b"

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
    url "https://gist.githubusercontent.com/waltarix/1399751/raw/6c8f54ec8e55823fb99b644a8a5603847cb60882/tmux-pane-border-ascii.patch"
    sha256 "2019e69de97882b11ba0bf0dcbf29d25f4744576a33ad9909a62329609bfdf40"
  end

  patch do
    url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-2.3-fix.diff"
    sha256 "afadff78e831c18c6c79ddba29c970425b7c08398ef00bde691f3fdeae866423"
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
