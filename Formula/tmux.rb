class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    tmux_version = "2.8"
    url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
    sha256 "7f6bf335634fafecff878d78de389562ea7f73a7367f268b66d37ea13617a2ba"
    version tmux_version

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
      sha256 "55f5d4aecf8ed6684d20d5659a591a15706c1a0b2a0f798a59c2c4514a85a92c"
    end
  end

  devel do
    url "https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9-rc3.tar.gz"
    sha256 "ef3f012f0f92b1a0947cb1183f14308296bebdc75099be90b01874551d762290"

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-2.9-rc3-fix.diff"
      sha256 "17c3ea036998fb1e09f131af760627977246ee9d75ed258615fc20f74b5c7ffa"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"
      
    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-HEAD-e6ee3e95-fix.diff"
      sha256 "50c783c1df73ac15261d522794d9428556b641d262e3c82eefcd9d904a106883"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "z80oolong/tmux/libevent@2.2"
  depends_on "utf8proc" => :optional
  depends_on "ncurses" unless OS.mac?

  option "with-version-master", "In head build, set the version of tmux as `master`."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    ENV.append "CFLAGS",   "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["z80oolong/tmux/libevent@2.2"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["z80oolong/tmux/libevent@2.2"].opt_lib}"

    if build.head? && build.with?("version-master") then
      inreplace "configure.ac" do |s|
        s.gsub!(/AC_INIT\(\[tmux\],[^)]*\)/, "AC_INIT([tmux], master)")
      end
    end

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
