class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  revision 1

  stable do
    tmux_version = "2.9a"
    url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
    sha256 "839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25"
    version tmux_version

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
      sha256 "5225429d53b01119dfba3326d4f420ab3851d8da8b00e44dd7dbb4d5f4713ed4"
    end
  end

  devel do
    tmux_version = "3.0-rc4"
    url "https://github.com/tmux/tmux/releases/download/3.0/tmux-#{tmux_version}.tar.gz"
    sha256 "98f8ac715f4d4b2297b2bd947925dd24d40aa16a849074a55029156157ac7663"
    version tmux_version

    patch do
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-#{tmux_version}-fix.diff"
      sha256 "cc4b6f1c762635a9e91cede8fb5cef72b569b32439d0fa764f9dc9073ac46042"
    end
  end

  head do
    url "https://github.com/tmux/tmux.git"

    patch do
#      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-HEAD-648471ec-fix.diff"
      url "https://github.com/z80oolong/tmux-eaw-fix/raw/master/tmux-HEAD-2e90841f-fix.diff"
#      sha256 "ea2da6a80607008735982b2cb95e862b6adfe559155f4d77ba76c688b8d7cc18"
      sha256 "830fd0ac20b95db8e64a46de669196b0da6d55adb7a16b220c084ab507d6f9f4"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "bison" => :build
  end

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
