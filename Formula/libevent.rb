class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/d057c45e8f48aa90d8b340cac4c8ae4cc8b5d0ac.zip"
  sha256 "c312b12a9db35adcb7194adb4df27b52856f53577d203d4b8f3fb0318f8395e2"
  version "2.2.0-alpha-dev"

  head do
    url "http://github.com/libevent/libevent.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
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
