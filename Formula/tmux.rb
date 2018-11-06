class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    url "https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz"
    sha256 "9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-2.7-fix.diff"
      sha256 "5ffde6a168226783e167bb9755def9c8104a06bd83a0bb22a35b7384e1023f04"
    end
  end

  devel do
    url "https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8-rc.tar.gz"
    sha256 "d0c0b1dd455ee701612007ed070bb5e02ee9f444fb8d8cbf7cb64d2faafb1ca9"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-2.8-rc-fix.diff"
      sha256 "55f5d4aecf8ed6684d20d5659a591a15706c1a0b2a0f798a59c2c4514a85a92c"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"
      
    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-HEAD-b1ad075d-fix.diff"
      sha256 "439c55656c5af26f321613302fb5d64f77456031b5a2f02a2403e6e857bbc3e9"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/libevent@2.2"].opt_lib}"

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
