class TmuxNcursesAT62 < Formula
  desc "Text-based UI library for tmux."
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.2.tar.gz"
  sha256 "30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d"
  version "6.2"
  revision 1

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gpatch" => :build unless OS.mac?

  patch :p1, :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-terminfo-dirs=#{opt_share}/terminfo:#{share}/terminfo",
                          "--with-default-terminfo-dir=#{share}/terminfo",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--with-shared",
                          "--with-gpm=no",
                          *("--without-ada" unless OS.mac?)
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]
    minor = version.to_s.split(".")[1]

    %w[form menu ncurses panel].each do |name|
      if OS.mac?
        (lib/"lib#{name}w.#{major}.dylib").rename(lib/"lib#{name}w-eaw.#{major}.dylib")
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}w-eaw.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}w.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}-eaw.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}.#{major}.dylib"
        lib.install_symlink "lib#{name}w-eaw.#{major}.dylib" => "lib#{name}w.#{major}.dylib"
      else
        (lib/"lib#{name}w.so.#{major}.#{minor}").rename(lib/"lib#{name}w-eaw.so.#{major}.#{minor}")
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}-eaw.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w-eaw.so"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}.so.#{major}"
        lib.install_symlink "lib#{name}w-eaw.so.#{major}.#{minor}" => "lib#{name}w.so.#{major}"
      end
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    if OS.mac?
      lib.install_symlink "libncurses.dylib" => "libcurses.dylib"
    else
      lib.install_symlink "libncurses.so" => "libcurses.so"
      lib.install_symlink "libncurses.so" => "libtermcap.so"
      lib.install_symlink "libncurses.so" => "libtinfo.so"
    end

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"
    (lib/"pkgconfig").install_symlink "formw.pc" => "form.pc"
    (lib/"pkgconfig").install_symlink "menuw.pc" => "menu.pc"
    (lib/"pkgconfig").install_symlink "panelw.pc" => "panel.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end

__END__
diff --git a/ncurses/curses.priv.h b/ncurses/curses.priv.h
index 9ca0263a..d4704ee2 100644
--- a/ncurses/curses.priv.h
+++ b/ncurses/curses.priv.h
@@ -2736,6 +2736,17 @@ NCURSES_EXPORT(int) _nc_conv_to_utf8(unsigned char *, unsigned, unsigned);
 NCURSES_EXPORT(int) _nc_conv_to_utf32(unsigned *, const char *, unsigned);
 #endif
 
+#ifndef NO_USE_UTF8CJK
+extern int _nc_wcwidth_cjk(wchar_t ucs);
+extern int _nc_wcswidth_cjk(const wchar_t *pwcs, size_t n);
+
+#undef wcwidth
+#undef wcswidth
+
+#define wcwidth(ucs)        _nc_wcwidth_cjk((ucs))
+#define wcswidth(pwcs, n)   _nc_wcswidth_cjk((pwcs), (n))
+#endif
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/ncurses/wcwidth.h b/ncurses/wcwidth.h
index e2611701..93c89494 100644
--- a/ncurses/wcwidth.h
+++ b/ncurses/wcwidth.h
@@ -310,3 +310,92 @@ int mk_wcswidth_cjk(const wchar_t *pwcs, size_t n)
 
   return width;
 }
+
+#ifndef NO_USE_UTF8CJK
+#ifndef NO_USE_UTF8CJK_EMOJI
+/* The following functions are the same as mk_wcwidth_cjk() and
+ * mk_wcswidth_cjk(), except that spacing characters in the "Emoji"
+ * characters as defined in Unicode have a column width of 2.
+ * This function is based on the following vim-jp issue,
+ * by Mr.mattn <https://github.com/mattn>.
+ *
+ * https://github.com/vim-jp/issues/issues/1086
+ */
+int mk_wcwidth_cjk_emoji(wchar_t ucs)
+{
+  /* Sorted list of non-overlapping intervals of all Emoji characters,
+   * based on http://unicode.org/emoji/charts/emoji-list.html */
+
+  static const struct interval emoji_all[] = {
+    { 0x203c, 0x203c }, { 0x2049, 0x2049 }, { 0x2122, 0x2122 },
+    { 0x2139, 0x2139 }, { 0x2194, 0x2199 }, { 0x21a9, 0x21aa },
+    { 0x231a, 0x231b }, { 0x2328, 0x2328 }, { 0x23cf, 0x23cf },
+    { 0x23e9, 0x23f3 }, { 0x23f8, 0x23fa }, { 0x24c2, 0x24c2 },
+    { 0x25aa, 0x25ab }, { 0x25b6, 0x25b6 }, { 0x25c0, 0x25c0 },
+    { 0x25fb, 0x25fe }, { 0x2600, 0x2604 }, { 0x260e, 0x260e },
+    { 0x2611, 0x2611 }, { 0x2614, 0x2615 }, { 0x2618, 0x2618 },
+    { 0x261d, 0x261d }, { 0x2620, 0x2620 }, { 0x2622, 0x2623 },
+    { 0x2626, 0x2626 }, { 0x262a, 0x262a }, { 0x262e, 0x262f },
+    { 0x2638, 0x263a }, { 0x2640, 0x2640 }, { 0x2642, 0x2642 },
+    { 0x2648, 0x2653 }, { 0x2660, 0x2660 }, { 0x2663, 0x2663 },
+    { 0x2665, 0x2666 }, { 0x2668, 0x2668 }, { 0x267b, 0x267b },
+    { 0x267f, 0x267f }, { 0x2692, 0x2697 }, { 0x2699, 0x2699 },
+    { 0x269b, 0x269c }, { 0x26a0, 0x26a1 }, { 0x26aa, 0x26ab },
+    { 0x26b0, 0x26b1 }, { 0x26bd, 0x26be }, { 0x26c4, 0x26c5 },
+    { 0x26c8, 0x26c8 }, { 0x26ce, 0x26cf }, { 0x26d1, 0x26d1 },
+    { 0x26d3, 0x26d4 }, { 0x26e9, 0x26ea }, { 0x26f0, 0x26f5 },
+    { 0x26f7, 0x26fa }, { 0x26fd, 0x26fd }, { 0x2702, 0x2702 },
+    { 0x2705, 0x2705 }, { 0x2708, 0x270d }, { 0x270f, 0x270f },
+    { 0x2712, 0x2712 }, { 0x2714, 0x2714 }, { 0x2716, 0x2716 },
+    { 0x271d, 0x271d }, { 0x2721, 0x2721 }, { 0x2728, 0x2728 },
+    { 0x2733, 0x2734 }, { 0x2744, 0x2744 }, { 0x2747, 0x2747 },
+    { 0x274c, 0x274c }, { 0x274e, 0x274e }, { 0x2753, 0x2755 },
+    { 0x2757, 0x2757 }, { 0x2763, 0x2764 }, { 0x2795, 0x2797 },
+    { 0x27a1, 0x27a1 }, { 0x27b0, 0x27b0 }, { 0x27bf, 0x27bf },
+    { 0x2934, 0x2935 }, { 0x2b05, 0x2b07 }, { 0x2b1b, 0x2b1c },
+    { 0x2b50, 0x2b50 }, { 0x2b55, 0x2b55 }, { 0x3030, 0x3030 },
+    { 0x303d, 0x303d }, { 0x3297, 0x3297 }, { 0x3299, 0x3299 },
+    { 0x1f004, 0x1f004 }, { 0x1f0cf, 0x1f0cf }, { 0x1f170, 0x1f171 },
+    { 0x1f17e, 0x1f17f }, { 0x1f18e, 0x1f18e }, { 0x1f191, 0x1f19a },
+    { 0x1f1e6, 0x1f1ff }, { 0x1f201, 0x1f202 }, { 0x1f21a, 0x1f21a },
+    { 0x1f22f, 0x1f22f }, { 0x1f232, 0x1f23a }, { 0x1f250, 0x1f251 },
+    { 0x1f300, 0x1f321 }, { 0x1f324, 0x1f393 }, { 0x1f396, 0x1f397 },
+    { 0x1f399, 0x1f39b }, { 0x1f39e, 0x1f3f0 }, { 0x1f3f3, 0x1f3f5 },
+    { 0x1f3f7, 0x1f4fd }, { 0x1f4ff, 0x1f53d }, { 0x1f549, 0x1f54e },
+    { 0x1f550, 0x1f567 }, { 0x1f56f, 0x1f570 }, { 0x1f573, 0x1f57a },
+    { 0x1f587, 0x1f587 }, { 0x1f58a, 0x1f58d }, { 0x1f590, 0x1f590 },
+    { 0x1f595, 0x1f596 }, { 0x1f5a4, 0x1f5a5 }, { 0x1f5a8, 0x1f5a8 },
+    { 0x1f5b1, 0x1f5b2 }, { 0x1f5bc, 0x1f5bc }, { 0x1f5c2, 0x1f5c4 },
+    { 0x1f5d1, 0x1f5d3 }, { 0x1f5dc, 0x1f5de }, { 0x1f5e1, 0x1f5e1 },
+    { 0x1f5e3, 0x1f5e3 }, { 0x1f5e8, 0x1f5e8 }, { 0x1f5ef, 0x1f5ef },
+    { 0x1f5f3, 0x1f5f3 }, { 0x1f5fa, 0x1f64f }, { 0x1f680, 0x1f6c5 },
+    { 0x1f6cb, 0x1f6d2 }, { 0x1f6e0, 0x1f6e5 }, { 0x1f6e9, 0x1f6e9 },
+    { 0x1f6eb, 0x1f6ec }, { 0x1f6f0, 0x1f6f0 }, { 0x1f6f3, 0x1f6f8 },
+    { 0x1f910, 0x1f93a }, { 0x1f93c, 0x1f93e }, { 0x1f940, 0x1f945 },
+    { 0x1f947, 0x1f94c }, { 0x1f950, 0x1f96b }, { 0x1f980, 0x1f997 },
+    { 0x1f9c0, 0x1f9c0 }, { 0x1f9d0, 0x1f9e6 }
+  };
+
+  /* binary search in table of non-spacing characters */
+  if (bisearch(ucs, emoji_all,
+	       sizeof(emoji_all) / sizeof(struct interval) - 1))
+    return 2;
+
+  return mk_wcwidth_cjk(ucs);
+}
+
+
+int mk_wcswidth_cjk_emoji(const wchar_t *pwcs, size_t n)
+{
+  int w, width = 0;
+
+  for (;*pwcs && n-- > 0; pwcs++)
+    if ((w = mk_wcwidth_cjk_emoji(*pwcs)) < 0)
+      return -1;
+    else
+      width += w;
+
+  return width;
+}
+#endif
+#endif
diff --git a/ncurses/widechar/lib_wacs.c b/ncurses/widechar/lib_wacs.c
index 5b6f6da2..8061683f 100644
--- a/ncurses/widechar/lib_wacs.c
+++ b/ncurses/widechar/lib_wacs.c
@@ -35,6 +35,57 @@
 
 MODULE_ID("$Id: lib_wacs.c,v 1.20 2020/02/02 23:34:34 tom Exp $")
 
+#ifndef NO_USE_UTF8CJK
+#include <wcwidth.h>
+
+static bool _nc_environ_nonzero(const char *name)
+{
+    char *environ = getenv(name);
+
+    if (environ == NULL)
+        return false;
+
+    return (strcmp(environ, "0") != 0);
+}
+
+#ifndef NO_USE_FOR_TMUX
+static int _nc_environ_cmp(const char *name, char *str)
+{
+    char *environ = getenv(name);
+
+    if (environ == NULL)
+      return 1;
+
+    return strcmp(environ, str);
+}
+#endif
+
+int _nc_wcwidth_cjk(wchar_t ucs)
+{
+    if (_nc_environ_nonzero("NCURSES_NO_UTF8CJK"))
+        return mk_wcwidth(ucs);
+#ifndef NO_USE_UTF8CJK_EMOJI
+    else if (_nc_environ_nonzero("NCURSES_NO_UTF8CJK_EMOJI"))
+        return mk_wcwidth_cjk(ucs);
+#endif
+
+    return mk_wcwidth_cjk_emoji(ucs);
+}
+
+int _nc_wcswidth_cjk(const wchar_t *pwcs, size_t n)
+{
+    int w, width = 0;
+
+    for (;*pwcs && n-- > 0; pwcs++)
+        if ((w = _nc_wcwidth_cjk(*pwcs)) < 0)
+            return -1;
+        else
+            width += w;
+
+    return width;
+}
+#endif
+
 NCURSES_EXPORT_VAR(cchar_t) * _nc_wacs = 0;
 
 NCURSES_EXPORT(void)
@@ -131,7 +182,25 @@ _nc_init_wacs(void)
 #endif
 
 	    m = table[n].map;
+#ifndef NO_USE_UTF8CJK
+#ifndef NO_USE_FOR_TMUX
+	    if (!_nc_environ_cmp("TMUX_ACS", "utf8") || !_nc_environ_cmp("TMUX_ACS", "utf-8")) {
+		unsetenv("NCURSES_NO_UTF8_ACS");
+		SetChar(_nc_wacs[m], table[n].value[1], A_NORMAL);
+	    } else if (!_nc_environ_cmp("TMUX_ACS", "ascii")) {
+		setenv("NCURSES_NO_UTF8_ACS", "1", 1);
+		setenv("NCURSES_USE_ASCII_ACS", "1", 1);
+		SetChar(_nc_wacs[m], table[n].value[0], A_NORMAL);
+	    } else if (_nc_environ_nonzero("NCURSES_USE_ASCII_ACS")) {
+#else
+	    if (_nc_environ_nonzero("NCURSES_USE_ASCII_ACS")) {
+#endif
+		setenv("NCURSES_NO_UTF8_ACS", "1", 1);
+		SetChar(_nc_wacs[m], table[n].value[0], A_NORMAL);
+	    } else if (active && (wide == 1)) {
+#else
 	    if (active && (wide == 1)) {
+#endif
 		SetChar(_nc_wacs[m], table[n].value[1], A_NORMAL);
 	    } else if (acs_map[m] & A_ALTCHARSET) {
 		SetChar(_nc_wacs[m], m, A_ALTCHARSET);
