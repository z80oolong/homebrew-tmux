class LibeventAT22 < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/archive/759573c9e17b0397aa1c6d2616c743551b8ca78d.zip"
  sha256 "aa4138869d482b244355519594f43e8dcd54cf593a5bc96b41d09bbcf403f66c" 
  version "2.2.0-beta-dev"
  revision 2

  option "with-doxygen", "With building doxygen."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  if build.with?("doxygen") then
    depends_on "z80oolong/tmux/doxygen@1.8" => :build
  end
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  keg_only :versioned_formula

  def install
    if build.with?("doxygen") then
      ENV["PATH"] = "#{Formula["z80oolong/tmux/doxygen@1.8"].opt_bin}:#{ENV["PATH"]}"

      inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with?("doxygen") then
      system "make", "doxygen"
      man3.install Dir["doxygen/man/man3/*.3"]
    end
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
