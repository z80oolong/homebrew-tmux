class LibeventAT22 < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/8483c5351abdd18766232de8431290165717bd57.zip"
  sha256 "0697880747f7252b563e13b6b52b22f568b26562e7eaa49cc2a69c5dfb10ad5c"
  version "2.2.0-beta-dev"
  revision 1

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "z80oolong/tmux/doxygen@1.8" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  keg_only :versioned_formula

  def install
    ENV["PATH"] = "#{Formula["z80oolong/tmux/doxygen@1.8"].opt_bin}:#{ENV["PATH"]}"

    inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "doxygen"
    man3.install Dir["doxygen/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end
