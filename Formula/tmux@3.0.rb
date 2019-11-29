class TmuxAT30 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "3.0"
  url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
  sha256 "9edcd78df80962ee2e6471a8f647602be5ded62bb41c574172bb3dc3d0b9b4b4"
  version tmux_version

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/tmux-libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  option "without-utf8-cjk", "Build without using East asian Ambiguous Width Character in tmux."
  option "without-pane-border-acs-ascii", "Build without using ACS ASCII as pane border in tmux."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  patch do
    url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
    sha256 "b5e994fc07d96b6bafcaa2dd984274662bd73f7cb4a916a4048ac0757bf7c97e"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/tmux-libevent@2.2"].opt_lib}"

    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK" if build.without?("utf8-cjk")
    ENV.append "CPPFLAGS", "-DNO_USE_PANE_BORDER_ACS_ASCII" if build.without?("pane-border-acs-ascii")

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
