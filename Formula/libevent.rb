class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/791e3de0c38f9f413f33addcac2d8bca68590ca6.zip"
  sha256 "3a169bc403db4e543b0a93c2e677d8b3f15b983482055aa3ddd8378fed047f80"
  version "2.2.0-beta-dev"

  head do
    url "http://github.com/libevent/libevent.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "z80oolong/tmux/doxygen" => :build
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
