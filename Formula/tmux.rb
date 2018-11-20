class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"

  stable do
    version "2.8"
    url "https://github.com/tmux/tmux/releases/download/#{version}/tmux-#{version}.tar.gz"
    sha256 "7f6bf335634fafecff878d78de389562ea7f73a7367f268b66d37ea13617a2ba"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-#{version}-fix.diff"
      sha256 "55f5d4aecf8ed6684d20d5659a591a15706c1a0b2a0f798a59c2c4514a85a92c"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"
      
    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/tmux/tmux-HEAD-0fd73f23-fix.diff"
      sha256 "439c55656c5af26f321613302fb5d64f77456031b5a2f02a2403e6e857bbc3e9"
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
