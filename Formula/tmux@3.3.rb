class TmuxAT33 < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  license "ISC"

  tmux_version = "3.3"
  url "https://github.com/tmux/tmux/releases/download/#{tmux_version}/tmux-#{tmux_version}.tar.gz"
  sha256 "b2382ac391f6a1c5b93293016cdc9488337d9a04b9d611ae05eac164740351dc"
  version tmux_version
  revision 9

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "z80oolong/tmux/tmux-ncurses@6.2"
  depends_on "utf8proc" => :optional

  on_linux do
    depends_on "patchelf" => :build
  end

  option "without-utf8-cjk", "Build without using East asian Ambiguous Width Character in tmux."
  option "without-utf8-emoji", "Build without using Emoji Character in tmux."
  option "without-pane-border-acs-ascii", "Build without using ACS ASCII as pane border in tmux."
  option "with-static-link", "Build tmux with static link."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  patch :p1, :DATA

  def install
    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK" if build.without?("utf8-cjk")
    ENV.append "CPPFLAGS", "-DNO_USE_UTF8CJK_EMOJI" if build.without?("utf8-emoji")
    ENV.append "CPPFLAGS", "-DNO_USE_PANE_BORDER_ACS_ASCII" if build.without?("pane-border-acs-ascii")

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if build.with?("utf8proc")
    args << "--enable-static"   if build.with?("static-link")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    if OS.linux? && !build.with?("static-link") then
      fix_rpath "#{bin}/tmux", ["z80oolong/tmux/tmux-ncurses@6.2"], ["ncurses"]
    end

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def fix_rpath(binname, append_list, delete_list)
    delete_list_hash = {}
    rpath = %x{#{Formula["patchelf"].opt_bin}/patchelf --print-rpath #{binname}}.chomp.split(":")

    (append_list + delete_list).each {|name| delete_list_hash["#{Formula[name].opt_lib}"] = true}
    rpath.delete_if {|path| delete_list_hash[path]}
    append_list.each {|name| rpath.unshift("#{Formula[name].opt_lib}")}

    system "#{Formula["patchelf"].opt_bin}/patchelf", "--set-rpath", "#{rpath.join(":")}", "#{binname}"
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  def diff_data
    lines = self.path.each_line.inject([]) do |result, line|
      result.push(line) if ((/^__END__/ === line) || result.first)
      result
    end
    lines.shift
    return lines.join("")
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end

__END__
diff --git a/options-table.c b/options-table.c
index 17be7ec..0291a4c 100644
--- a/options-table.c
+++ b/options-table.c
@@ -1210,6 +1210,38 @@ const struct options_table_entry options_table[] = {
 		  "This option is no longer used."
 	},
 
+#ifndef NO_USE_UTF8CJK
+	/* UTF8 East asian Ambiguous Width charactor options. */
+	{ .name = "utf8-cjk",
+	  .type = OPTIONS_TABLE_FLAG,
+	  .scope = OPTIONS_TABLE_SERVER,
+	  .default_num = 1
+	},
+
+#ifndef NO_USE_UTF8CJK_EMOJI
+	/* UTF8 Emoji charactor options. */
+	{ .name = "utf8-emoji",
+	  .type = OPTIONS_TABLE_FLAG,
+	  .scope = OPTIONS_TABLE_SERVER,
+	  .default_num = 1
+	},
+#endif
+#endif
+
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+	{ .name = "pane-border-acs",
+	  .type = OPTIONS_TABLE_FLAG,
+	  .scope = OPTIONS_TABLE_SESSION,
+	  .default_num = 0
+	},
+
+	{ .name = "pane-border-ascii",
+	  .type = OPTIONS_TABLE_FLAG,
+	  .scope = OPTIONS_TABLE_SESSION,
+	  .default_num = 0
+	},
+#endif
+
 	/* Hook options. */
 	OPTIONS_TABLE_HOOK("after-bind-key", ""),
 	OPTIONS_TABLE_HOOK("after-capture-pane", ""),
diff --git a/tmux.c b/tmux.c
index b9f2be3..b4c68a6 100644
--- a/tmux.c
+++ b/tmux.c
@@ -333,20 +333,33 @@ main(int argc, char **argv)
 {
 	char					*path = NULL, *label = NULL;
 	char					*cause, **var;
+#ifndef NO_USE_UTF8CJK
+	char					*ctype;
+#endif
 	const char				*s, *cwd;
 	int					 opt, keys, feat = 0, fflag = 0;
 	uint64_t				 flags = 0;
 	const struct options_table_entry	*oe;
 	u_int					 i;
+#ifndef NO_USE_ENV_TMUX_CONF
+	struct environ_entry			*tmux_conf_entry;
+	char					*tmux_conf;
+#endif
 
+#ifdef NO_USE_UTF8CJK
 	if (setlocale(LC_CTYPE, "en_US.UTF-8") == NULL &&
 	    setlocale(LC_CTYPE, "C.UTF-8") == NULL) {
 		if (setlocale(LC_CTYPE, "") == NULL)
+#else
+		if ((ctype = setlocale(LC_CTYPE, "")) == NULL)
+#endif
 			errx(1, "invalid LC_ALL, LC_CTYPE or LANG");
 		s = nl_langinfo(CODESET);
 		if (strcasecmp(s, "UTF-8") != 0 && strcasecmp(s, "UTF8") != 0)
 			errx(1, "need UTF-8 locale (LC_CTYPE) but have %s", s);
+#ifdef NO_USE_UTF8CJK
 	}
+#endif
 
 	setlocale(LC_TIME, "");
 	tzset();
@@ -359,7 +372,16 @@ main(int argc, char **argv)
 		environ_put(global_environ, *var, 0);
 	if ((cwd = find_cwd()) != NULL)
 		environ_set(global_environ, "PWD", 0, "%s", cwd);
+#ifdef NO_USE_ENV_TMUX_CONF
 	expand_paths(TMUX_CONF, &cfg_files, &cfg_nfiles, 1);
+#else
+	if ((tmux_conf_entry = environ_find(global_environ, "TMUX_CONF")) == NULL) {
+		expand_paths(TMUX_CONF, &cfg_files, &cfg_nfiles, 1);
+	} else {
+		tmux_conf = xstrdup(tmux_conf_entry->value);
+		expand_paths(tmux_conf, &cfg_files, &cfg_nfiles, 1);
+	}
+#endif
 
 	while ((opt = getopt(argc, argv, "2c:CDdf:lL:NqS:T:uUvV")) != -1) {
 		switch (opt) {
@@ -490,6 +512,19 @@ main(int argc, char **argv)
 		options_set_number(global_w_options, "mode-keys", keys);
 	}
 
+#ifndef NO_USE_UTF8CJK
+	if (!strncmp(ctype, "ja", 2) || !strncmp(ctype, "ko", 2) || !strncmp(ctype, "zh", 2)) {
+		options_set_number(global_options, "utf8-cjk", 1);
+#ifndef NO_USE_UTF8CJK_EMOJI
+		options_set_number(global_options, "utf8-emoji", 1);
+#endif
+	} else {
+		options_set_number(global_options, "utf8-cjk", 0);
+#ifndef NO_USE_UTF8CJK_EMOJI
+		options_set_number(global_options, "utf8-emoji", 0);
+#endif
+	}
+#endif
 	/*
 	 * If socket is specified on the command-line with -S or -L, it is
 	 * used. Otherwise, $TMUX is checked and if that fails "default" is
@@ -515,6 +550,13 @@ main(int argc, char **argv)
 	socket_path = path;
 	free(label);
 
+#ifndef NO_USE_FIX_NOEPOLL
+#ifdef __linux__
+	/* Set the environment variable EVENT_NOEPOLL to "1" certainly. */
+	environ_set(global_environ, "EVENT_NOEPOLL", 0, "%d", 1);
+#endif
+#endif
+
 	/* Pass control to the client. */
 	exit(client_main(osdep_event_init(), argc, argv, flags, feat));
 }
diff --git a/tmux.h b/tmux.h
index 53084b8..0381eb7 100644
--- a/tmux.h
+++ b/tmux.h
@@ -80,6 +80,17 @@ struct winlink;
 #define TMUX_TERM "screen"
 #endif
 
+/* If "pane-border-ascii" is not used, "utf8-cjk" is not used too. */
+#ifdef NO_USE_PANE_BORDER_ASCII
+#ifndef NO_USE_UTF8CJK
+#define NO_USE_UTF8CJK
+#endif
+#endif
+
+#ifdef NO_USE_UTF8CJK
+#define NO_USE_UTF8CJK_EMOJI
+#endif
+
 /* Minimum layout cell size, NOT including border lines. */
 #define PANE_MINIMUM 1
 
diff --git a/tty-acs.c b/tty-acs.c
index 64ba367..0692c5b 100644
--- a/tty-acs.c
+++ b/tty-acs.c
@@ -23,6 +23,217 @@
 
 #include "tmux.h"
 
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+#include <string.h>
+
+static const char tty_acs_table[UCHAR_MAX][4] = {
+	['+'] = "\342\206\222",	/* arrow pointing right */
+	[','] = "\342\206\220",	/* arrow pointing left */
+	['-'] = "\342\206\221",	/* arrow pointing up */
+	['.'] = "\342\206\223",	/* arrow pointing down */
+	['0'] = "\342\226\256",	/* solid square block */
+	['`'] = "\342\227\206",	/* diamond */
+	['a'] = "\342\226\222",	/* checker board (stipple) */
+	['b'] = "\342\220\211",
+	['c'] = "\342\220\214",
+	['d'] = "\342\220\215",
+	['e'] = "\342\220\212",
+	['f'] = "\302\260",	/* degree symbol */
+	['g'] = "\302\261",	/* plus/minus */
+	['h'] = "\342\220\244",
+	['i'] = "\342\220\213",
+	['j'] = "\342\224\230",	/* lower right corner */
+	['k'] = "\342\224\220",	/* upper right corner */
+	['l'] = "\342\224\214",	/* upper left corner */
+	['m'] = "\342\224\224",	/* lower left corner */
+	['n'] = "\342\224\274",	/* large plus or crossover */
+	['o'] = "\342\216\272",	/* scan line 1 */
+	['p'] = "\342\216\273",	/* scan line 3 */
+	['q'] = "\342\224\200",	/* horizontal line */
+	['r'] = "\342\216\274",	/* scan line 7 */
+	['s'] = "\342\216\275",	/* scan line 9 */
+	['t'] = "\342\224\234",	/* tee pointing right */
+	['u'] = "\342\224\244",	/* tee pointing left */
+	['v'] = "\342\224\264",	/* tee pointing up */
+	['w'] = "\342\224\254",	/* tee pointing down */
+	['x'] = "\342\224\202",	/* vertical line */
+	['y'] = "\342\211\244",	/* less-than-or-equal-to */
+	['z'] = "\342\211\245",	/* greater-than-or-equal-to */
+	['{'] = "\317\200",	/* greek pi */
+	['|'] = "\342\211\240",	/* not-equal */
+	['}'] = "\302\243",	/* UK pound sign */
+	['~'] = "\302\267",	/* bullet */
+};
+
+static char tty_acs_ascii_table[UCHAR_MAX][2] = {
+	['}'] = "f",	/* UK pound sign		ACS_STERLING	*/
+	['.'] = "v",	/* arrow pointing down		ACS_DARROW	*/
+	[','] = "<",	/* arrow pointing left		ACS_LARROW	*/
+	['+'] = ">",	/* arrow pointing right		ACS_RARROW	*/
+	['-'] = "^",	/* arrow pointing up		ACS_UARROW	*/
+	['h'] = "#",	/* board of squares		ACS_BOARD	*/
+	['~'] = "o",	/* bullet			ACS_BULLET	*/
+	['a'] = ":",	/* checker board (stipple)	ACS_CKBOARD	*/
+	['f'] = "\\",	/* degree symbol		ACS_DEGREE	*/
+	['`'] = "+",	/* diamond			ACS_DIAMOND	*/
+	['z'] = ">",	/* greater-than-or-equal-to	ACS_GEQUAL	*/
+	['{'] = "*",	/* greek pi			ACS_PI		*/
+	['q'] = "-",	/* horizontal line		ACS_HLINE	*/
+	['i'] = "#",	/* lantern symbol		ACS_LANTERN	*/
+	['n'] = "+",	/* large plus or crossover	ACS_PLUS	*/
+	['y'] = "<",	/* less-than-or-equal-to	ACS_LEQUAL	*/
+	['m'] = "+",	/* lower left corner		ACS_LLCORNER	*/
+	['j'] = "+",	/* lower right corner		ACS_LRCORNER	*/
+	['|'] = "!",	/* not-equal			ACS_NEQUAL	*/
+	['g'] = "#",	/* plus/minus			ACS_PLMINUS	*/
+	['o'] = "~",	/* scan line 1			ACS_S1		*/
+	['p'] = "-",	/* scan line 3			ACS_S3		*/
+	['r'] = "-",	/* scan line 7			ACS_S7		*/
+	['s'] = "_",	/* scan line 9			ACS_S9		*/
+	['0'] = "#",	/* solid square block		ACS_BLOCK	*/
+	['w'] = "+",	/* tee pointing down		ACS_TTEE	*/
+	['u'] = "+",	/* tee pointing left		ACS_RTEE	*/
+	['t'] = "+",	/* tee pointing right		ACS_LTEE	*/
+	['v'] = "+",	/* tee pointing up		ACS_BTEE	*/
+	['l'] = "+",	/* upper left corner		ACS_ULCORNER	*/
+	['k'] = "+",	/* upper right corner		ACS_URCORNER	*/
+	['x'] = "|",	/* vertical line		ACS_VLINE	*/
+};
+
+static int tty_acs_reverse_table[USHRT_MAX][1] = {
+       [0xfb1d] = 0x7e,        /* "\302\267"     = '~' */
+       [0xcd2e] = 0x71,        /* "\342\224\200" = 'q' */
+       [0xcd2f] = 0x71,        /* "\342\224\201" = 'q' */
+       [0xcd30] = 0x78,        /* "\342\224\202" = 'x' */
+       [0xcd31] = 0x78,        /* "\342\224\203" = 'x' */
+       [0xcd3a] = 0x6c,        /* "\342\224\214" = 'l' */
+       [0xcd3d] = 0x6b,        /* "\342\224\217" = 'k' */
+       [0xcd3e] = 0x6b,        /* "\342\224\220" = 'k' */
+       [0xcd41] = 0x6c,        /* "\342\224\223" = 'l' */
+       [0xcd42] = 0x6d,        /* "\342\224\224" = 'm' */
+       [0xcd45] = 0x6d,        /* "\342\224\227" = 'm' */
+       [0xcd46] = 0x6a,        /* "\342\224\230" = 'j' */
+       [0xcd49] = 0x6a,        /* "\342\224\233" = 'j' */
+       [0xcd4a] = 0x74,        /* "\342\224\234" = 't' */
+       [0xcd51] = 0x74,        /* "\342\224\243" = 't' */
+       [0xcd52] = 0x75,        /* "\342\224\244" = 'u' */
+       [0xcd59] = 0x75,        /* "\342\224\253" = 'u' */
+       [0xcd61] = 0x77,        /* "\342\224\263" = 'w' */
+       [0xcd62] = 0x76,        /* "\342\224\264" = 'v' */
+       [0xcd69] = 0x76,        /* "\342\224\273" = 'v' */
+       [0xcd6a] = 0x6e,        /* "\342\224\274" = 'n' */
+       [0xcd4c] = 0x6e,        /* "\342\225\213" = 'n' */
+       [0xcd51] = 0x71,        /* "\342\225\220" = 'q' */
+       [0xcd52] = 0x78,        /* "\342\225\221" = 'x' */
+       [0xcd55] = 0x6c,        /* "\342\225\224" = 'l' */
+       [0xcd58] = 0x6b,        /* "\342\225\227" = 'k' */
+       [0xcd5b] = 0x6d,        /* "\342\225\232" = 'm' */
+       [0xcd5e] = 0x6a,        /* "\342\225\235" = 'j' */
+       [0xcd61] = 0x74,        /* "\342\225\240" = 't' */
+       [0xcd64] = 0x75,        /* "\342\225\243" = 'u' */
+       [0xcd67] = 0x77,        /* "\342\225\246" = 'w' */
+       [0xcd6a] = 0x76,        /* "\342\225\251" = 'v' */
+       [0xcd6d] = 0x6e,        /* "\342\225\254" = 'n' */
+};
+
+static int
+acs_reverse_hash(const char *str, size_t strlen)
+{
+	int result;
+
+	for (result = 0; (strlen > 0) || (*str != '\0'); str++, strlen--)
+		result = 19 * result + ((int)*str);
+
+	return (result & 0xffff);
+}
+
+/* UTF-8 double borders. */
+static const struct utf8_data tty_acs_double_borders_list[][2] = {
+	{ { "", 0, 0, 0 }, { "", 0, 0, 0 } },
+	{ { "\342\225\221", 0, 3, 1 }, { "|", 0, 1, 1 } }, /* U+2551 */
+	{ { "\342\225\220", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2550 */
+	{ { "\342\225\224", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2554 */
+	{ { "\342\225\227", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2557 */
+	{ { "\342\225\232", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+255A */
+	{ { "\342\225\235", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+255D */
+	{ { "\342\225\246", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2566 */
+	{ { "\342\225\251", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2569 */
+	{ { "\342\225\240", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2560 */
+	{ { "\342\225\243", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2563 */
+	{ { "\342\225\254", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+256C */
+	{ { "\302\267",	0, 2, 1 }, { "o", 0, 1, 1 } }  /* U+00B7 */
+};
+
+/* UTF-8 heavy borders. */
+static const struct utf8_data tty_acs_heavy_borders_list[][2] = {
+	{ { "", 0, 0, 0 }, { "", 0, 0, 0 } },
+	{ { "\342\224\203", 0, 3, 1 }, { "|", 0, 1, 1 } }, /* U+2503 */
+	{ { "\342\224\201", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2501 */
+	{ { "\342\224\217", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+250F */
+	{ { "\342\224\223", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2513 */
+	{ { "\342\224\227", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2517 */
+	{ { "\342\224\233", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+251B */
+	{ { "\342\224\263", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2533 */
+	{ { "\342\224\273", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+253B */
+	{ { "\342\224\243", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+2523 */
+	{ { "\342\224\253", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+252B */
+	{ { "\342\225\213", 0, 3, 1 }, { "+", 0, 1, 1 } }, /* U+254B */
+	{ { "\302\267", 0, 2, 1 }, { "o", 0, 1, 1 } }  /* U+00B7 */
+};
+
+/* UTF-8 rounded borders. */
+static const struct utf8_data tty_acs_rounded_borders_list[][2] = {
+	{ { "", 0, 0, 0 }, { "", 0, 0, 0 } },
+	{ { "\342\224\202", 0, 3, 1 }, { "|", 0, 1, 1 } },/* U+2502 */
+	{ { "\342\224\200", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+2500 */
+	{ { "\342\225\255", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+256D */
+	{ { "\342\225\256", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+256E */
+	{ { "\342\225\260", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+2570 */
+	{ { "\342\225\257", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+256F */
+	{ { "\342\224\263", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+2533 */
+	{ { "\342\224\273", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+253B */
+	{ { "\342\224\243", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+2523 */
+	{ { "\342\224\253", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+252B */
+	{ { "\342\225\213", 0, 3, 1 }, { "+", 0, 1, 1 } },/* U+254B */
+	{ { "\302\267", 0, 2, 1 }, { "o", 0, 1, 1 } }  /* U+00B7 */
+};
+
+static int
+tty_acs_borders_list_index(void)
+{
+	static int index = -1;
+
+	if (index < 0) {
+		if (options_get_number(global_s_options, "pane-border-acs"))
+			index = 0;
+		else if (options_get_number(global_s_options, "pane-border-ascii"))
+			index = 1;
+	}
+
+	return index;
+}
+
+/* Get cell border character for double style. */
+const struct utf8_data *
+tty_acs_double_borders(int cell_type)
+{
+	return (&tty_acs_double_borders_list[cell_type][tty_acs_borders_list_index()]);
+}
+
+/* Get cell border character for heavy style. */
+const struct utf8_data *
+tty_acs_heavy_borders(int cell_type)
+{
+	return (&tty_acs_heavy_borders_list[cell_type][tty_acs_borders_list_index()]);
+}
+
+/* Get cell border character for rounded style. */
+const struct utf8_data *
+tty_acs_rounded_borders(int cell_type)
+{
+	return (&tty_acs_rounded_borders_list[cell_type][tty_acs_borders_list_index()]);
+}
+#else
 /* Table mapping ACS entries to UTF-8. */
 struct tty_acs_entry {
 	u_char		 key;
@@ -199,11 +410,91 @@ tty_acs_reverse_cmp(const void *key, const void *value)
 
 	return (strcmp(test, entry->string));
 }
+#endif  /* NO_USE_PANE_BORDER_ACS_ASCII */
+
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+static int
+get_utf8_width(const char *s)
+{
+	const char		*p = s;
+	struct utf8_data	 ud;
+	enum utf8_state		 more;
+
+	for (more = utf8_open(&ud, *p++); more == UTF8_MORE; more = utf8_append(&ud, *p++))
+		;
+	if (more != UTF8_DONE)
+		fatalx("INTERNAL ERROR: In get_utf8_width, utf8_open or utf8_append return error %d", more);
+	log_debug("%s width is %d", s, ud.width);
+	return ud.width;
+}
+
+enum acs_type {
+	ACST_UTF8,
+	ACST_ACS,
+	ACST_ASCII,
+};
+
+static enum acs_type
+tty_acs_type(struct tty *tty)
+{
+	if (tty == NULL)
+		return (ACST_ASCII);
+
+	/*
+	 * If the U8 flag is present, it marks whether a terminal supports
+	 * UTF-8 and ACS together.
+	 *
+	 * If it is present and zero, we force ACS - this gives users a way to
+	 * turn off UTF-8 line drawing.
+	 *
+	 * If it is nonzero, we can fall through to the default and use UTF-8
+	 * line drawing on UTF-8 terminals.
+	 */
+
+	struct environ_entry	*envent;
+	envent = environ_find(tty->client->environ, "TMUX_ACS");
+	if (envent != NULL) {
+		if (strcasestr(envent->value, "utf-8") != NULL ||
+		    strcasestr(envent->value, "utf8") != NULL)
+			return (ACST_UTF8);
+		else if (strcasestr(envent->value, "acs") != NULL)
+			return (ACST_ACS);
+		else
+			return (ACST_ASCII);
+	}
+
+	if (options_get_number(global_s_options, "pane-border-acs"))
+		return (ACST_ACS);
+	if (options_get_number(global_s_options, "pane-border-ascii"))
+		return (ACST_ASCII);
+
+	if ((tty->client->flags & CLIENT_UTF8) &&
+	    (!tty_term_has(tty->term, TTYC_U8) ||
+	     tty_term_number(tty->term, TTYC_U8) != 0)) {
+		static int hline_width = 0;
+		const char *hline = "\342\224\200";
+		if (hline_width == 0) {
+			hline_width = get_utf8_width(hline);
+			log_debug("hline_width=%d", hline_width);
+		}
+		if (hline_width == 1)
+			return (ACST_UTF8);
+	}
+
+	if (tty_term_has(tty->term, TTYC_ACSC))
+		return (ACST_ACS);
+
+	return (ACST_ASCII);
+}
+#endif /* NO_USE_PANE_BORDER_ACS_ASCII */
 
 /* Should this terminal use ACS instead of UTF-8 line drawing? */
 int
 tty_acs_needed(struct tty *tty)
 {
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+	return (tty_acs_type(tty) == ACST_ACS);
+#else
 	if (tty == NULL)
 		return (0);
 
@@ -224,12 +515,31 @@ tty_acs_needed(struct tty *tty)
 	if (tty->client->flags & CLIENT_UTF8)
 		return (0);
 	return (1);
+#endif /* NO_USE_PANE_BORDER_ACS_ASCII */
 }
 
 /* Retrieve ACS to output as UTF-8. */
 const char *
 tty_acs_get(struct tty *tty, u_char ch)
 {
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+	switch (tty_acs_type(tty)) {
+	case ACST_UTF8:
+		if (tty_acs_table[ch][0] != '\0')
+			return (&tty_acs_table[ch][0]);
+		break;
+	case ACST_ACS:
+		if (tty->term->acs[ch][0] != '\0')
+			return (&tty->term->acs[ch][0]);
+		break;
+	case ACST_ASCII:
+		break;
+	}
+
+	if (tty_acs_ascii_table[ch][0] != '\0')
+		return (&tty_acs_ascii_table[ch][0]);
+	return (NULL);
+#else
 	const struct tty_acs_entry	*entry;
 
 	/* Use the ACS set instead of UTF-8 if needed. */
@@ -245,12 +555,23 @@ tty_acs_get(struct tty *tty, u_char ch)
 	if (entry == NULL)
 		return (NULL);
 	return (entry->string);
+#endif /* NO_USE_PANE_BORDER_ACS_ASCII */
 }
 
 /* Reverse UTF-8 into ACS. */
 int
 tty_acs_reverse_get(__unused struct tty *tty, const char *s, size_t slen)
 {
+#ifndef NO_USE_PANE_BOARDER_ACS_ASCII
+	int ch;
+
+	if (tty_acs_type(tty) == ACST_UTF8) {
+		if ((ch = tty_acs_reverse_table[acs_reverse_hash(s, slen)][0]) != 0)
+			return ch;
+	}
+
+	return (-1);
+#else
 	const struct tty_acs_reverse_entry	*table, *entry;
 	u_int					 items;
 
@@ -266,4 +587,5 @@ tty_acs_reverse_get(__unused struct tty *tty, const char *s, size_t slen)
 	if (entry == NULL)
 		return (-1);
 	return (entry->key);
+#endif
 }
diff --git a/tty-term.c b/tty-term.c
index fdf0c4f..9d01e6a 100644
--- a/tty-term.c
+++ b/tty-term.c
@@ -503,6 +503,15 @@ tty_term_apply_overrides(struct tty_term *term)
 		term->flags &= ~TERM_NOAM;
 	log_debug("NOAM flag is %d", !!(term->flags & TERM_NOAM));
 
+#ifndef NO_USE_PANE_BORDER_ACS_ASCII
+	/* Generate ACS table. */
+	memset(term->acs, 0, sizeof term->acs);
+	if (tty_term_has(term, TTYC_ACSC)) {
+		acs = tty_term_string(term, TTYC_ACSC);
+		for (; acs[0] != '\0' && acs[1] != '\0'; acs += 2)
+			term->acs[(u_char) acs[0]][0] = acs[1];
+	}
+#else
 	/* Generate ACS table. If none is present, use nearest ASCII. */
 	memset(term->acs, 0, sizeof term->acs);
 	if (tty_term_has(term, TTYC_ACSC))
@@ -511,6 +520,7 @@ tty_term_apply_overrides(struct tty_term *term)
 		acs = "a#j+k+l+m+n+o-p-q-r-s-t+u+v+w+x|y<z>~.";
 	for (; acs[0] != '\0' && acs[1] != '\0'; acs += 2)
 		term->acs[(u_char) acs[0]][0] = acs[1];
+#endif
 }
 
 struct tty_term *
diff --git a/utf8.c b/utf8.c
index df75a76..7d5e012 100644
--- a/utf8.c
+++ b/utf8.c
@@ -26,6 +26,407 @@
 
 #include "tmux.h"
 
+#ifndef NO_USE_UTF8CJK
+/*
+ * This is an implementation of wcwidth() and wcswidth() (defined in
+ * IEEE Std 1002.1-2001) for Unicode.
+ *
+ * http://www.opengroup.org/onlinepubs/007904975/functions/wcwidth.html
+ * http://www.opengroup.org/onlinepubs/007904975/functions/wcswidth.html
+ *
+ * In fixed-width output devices, Latin characters all occupy a single
+ * "cell" position of equal width, whereas ideographic CJK characters
+ * occupy two such cells. Interoperability between terminal-line
+ * applications and (teletype-style) character terminals using the
+ * UTF-8 encoding requires agreement on which character should advance
+ * the cursor by how many cell positions. No established formal
+ * standards exist at present on which Unicode character shall occupy
+ * how many cell positions on character terminals. These routines are
+ * a first attempt of defining such behavior based on simple rules
+ * applied to data provided by the Unicode Consortium.
+ *
+ * For some graphical characters, the Unicode standard explicitly
+ * defines a character-cell width via the definition of the East Asian
+ * FullWidth (F), Wide (W), Half-width (H), and Narrow (Na) classes.
+ * In all these cases, there is no ambiguity about which width a
+ * terminal shall use. For characters in the East Asian Ambiguous (A)
+ * class, the width choice depends purely on a preference of backward
+ * compatibility with either historic CJK or Western practice.
+ * Choosing single-width for these characters is easy to justify as
+ * the appropriate long-term solution, as the CJK practice of
+ * displaying these characters as double-width comes from historic
+ * implementation simplicity (8-bit encoded characters were displayed
+ * single-width and 16-bit ones double-width, even for Greek,
+ * Cyrillic, etc.) and not any typographic considerations.
+ *
+ * Much less clear is the choice of width for the Not East Asian
+ * (Neutral) class. Existing practice does not dictate a width for any
+ * of these characters. It would nevertheless make sense
+ * typographically to allocate two character cells to characters such
+ * as for instance EM SPACE or VOLUME INTEGRAL, which cannot be
+ * represented adequately with a single-width glyph. The following
+ * routines at present merely assign a single-cell width to all
+ * neutral characters, in the interest of simplicity. This is not
+ * entirely satisfactory and should be reconsidered before
+ * establishing a formal standard in this area. At the moment, the
+ * decision which Not East Asian (Neutral) characters should be
+ * represented by double-width glyphs cannot yet be answered by
+ * applying a simple rule from the Unicode database content. Setting
+ * up a proper standard for the behavior of UTF-8 character terminals
+ * will require a careful analysis not only of each Unicode character,
+ * but also of each presentation form, something the author of these
+ * routines has avoided to do so far.
+ *
+ * http://www.unicode.org/unicode/reports/tr11/
+ *
+ * Markus Kuhn -- 2007-05-26 (Unicode 5.0)
+ *
+ * Permission to use, copy, modify, and distribute this software
+ * for any purpose and without fee is hereby granted. The author
+ * disclaims all warranties with regard to this software.
+ *
+ * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
+ */
+
+// Delete duplicated '#include <wchar.h>' by Z.OOL. <zool@zool.jpn.org>
+//#include <wchar.h>
+
+struct interval {
+  int first;
+  int last;
+};
+
+/* auxiliary function for binary search in interval table */
+static int bisearch(wchar_t ucs, const struct interval *table, int max) {
+  int min = 0;
+  int mid;
+
+  if (ucs < table[0].first || ucs > table[max].last)
+    return 0;
+  while (max >= min) {
+    mid = (min + max) / 2;
+    if (ucs > table[mid].last)
+      min = mid + 1;
+    else if (ucs < table[mid].first)
+      max = mid - 1;
+    else
+      return 1;
+  }
+
+  return 0;
+}
+
+
+/* The following two functions define the column width of an ISO 10646
+ * character as follows:
+ *
+ *    - The null character (U+0000) has a column width of 0.
+ *
+ *    - Other C0/C1 control characters and DEL will lead to a return
+ *      value of -1.
+ *
+ *    - Non-spacing and enclosing combining characters (general
+ *      category code Mn or Me in the Unicode database) have a
+ *      column width of 0.
+ *
+ *    - SOFT HYPHEN (U+00AD) has a column width of 1.
+ *
+ *    - Other format characters (general category code Cf in the Unicode
+ *      database) and ZERO WIDTH SPACE (U+200B) have a column width of 0.
+ *
+ *    - Hangul Jamo medial vowels and final consonants (U+1160-U+11FF)
+ *      have a column width of 0.
+ *
+ *    - Spacing characters in the East Asian Wide (W) or East Asian
+ *      Full-width (F) category as defined in Unicode Technical
+ *      Report #11 have a column width of 2.
+ *
+ *    - All remaining characters (including all printable
+ *      ISO 8859-1 and WGL4 characters, Unicode control characters,
+ *      etc.) have a column width of 1.
+ *
+ * This implementation assumes that wchar_t characters are encoded
+ * in ISO 10646.
+ */
+
+int mk_wcwidth(wchar_t ucs)
+{
+  /* sorted list of non-overlapping intervals of non-spacing characters */
+  /* generated by "uniset +cat=Me +cat=Mn +cat=Cf -00AD +1160-11FF +200B c" */
+  static const struct interval combining[] = {
+    { 0x0300, 0x036F }, { 0x0483, 0x0486 }, { 0x0488, 0x0489 },
+    { 0x0591, 0x05BD }, { 0x05BF, 0x05BF }, { 0x05C1, 0x05C2 },
+    { 0x05C4, 0x05C5 }, { 0x05C7, 0x05C7 }, { 0x0600, 0x0603 },
+    { 0x0610, 0x0615 }, { 0x064B, 0x065E }, { 0x0670, 0x0670 },
+    { 0x06D6, 0x06E4 }, { 0x06E7, 0x06E8 }, { 0x06EA, 0x06ED },
+    { 0x070F, 0x070F }, { 0x0711, 0x0711 }, { 0x0730, 0x074A },
+    { 0x07A6, 0x07B0 }, { 0x07EB, 0x07F3 }, { 0x0901, 0x0902 },
+    { 0x093C, 0x093C }, { 0x0941, 0x0948 }, { 0x094D, 0x094D },
+    { 0x0951, 0x0954 }, { 0x0962, 0x0963 }, { 0x0981, 0x0981 },
+    { 0x09BC, 0x09BC }, { 0x09C1, 0x09C4 }, { 0x09CD, 0x09CD },
+    { 0x09E2, 0x09E3 }, { 0x0A01, 0x0A02 }, { 0x0A3C, 0x0A3C },
+    { 0x0A41, 0x0A42 }, { 0x0A47, 0x0A48 }, { 0x0A4B, 0x0A4D },
+    { 0x0A70, 0x0A71 }, { 0x0A81, 0x0A82 }, { 0x0ABC, 0x0ABC },
+    { 0x0AC1, 0x0AC5 }, { 0x0AC7, 0x0AC8 }, { 0x0ACD, 0x0ACD },
+    { 0x0AE2, 0x0AE3 }, { 0x0B01, 0x0B01 }, { 0x0B3C, 0x0B3C },
+    { 0x0B3F, 0x0B3F }, { 0x0B41, 0x0B43 }, { 0x0B4D, 0x0B4D },
+    { 0x0B56, 0x0B56 }, { 0x0B82, 0x0B82 }, { 0x0BC0, 0x0BC0 },
+    { 0x0BCD, 0x0BCD }, { 0x0C3E, 0x0C40 }, { 0x0C46, 0x0C48 },
+    { 0x0C4A, 0x0C4D }, { 0x0C55, 0x0C56 }, { 0x0CBC, 0x0CBC },
+    { 0x0CBF, 0x0CBF }, { 0x0CC6, 0x0CC6 }, { 0x0CCC, 0x0CCD },
+    { 0x0CE2, 0x0CE3 }, { 0x0D41, 0x0D43 }, { 0x0D4D, 0x0D4D },
+    { 0x0DCA, 0x0DCA }, { 0x0DD2, 0x0DD4 }, { 0x0DD6, 0x0DD6 },
+    { 0x0E31, 0x0E31 }, { 0x0E34, 0x0E3A }, { 0x0E47, 0x0E4E },
+    { 0x0EB1, 0x0EB1 }, { 0x0EB4, 0x0EB9 }, { 0x0EBB, 0x0EBC },
+    { 0x0EC8, 0x0ECD }, { 0x0F18, 0x0F19 }, { 0x0F35, 0x0F35 },
+    { 0x0F37, 0x0F37 }, { 0x0F39, 0x0F39 }, { 0x0F71, 0x0F7E },
+    { 0x0F80, 0x0F84 }, { 0x0F86, 0x0F87 }, { 0x0F90, 0x0F97 },
+    { 0x0F99, 0x0FBC }, { 0x0FC6, 0x0FC6 }, { 0x102D, 0x1030 },
+    { 0x1032, 0x1032 }, { 0x1036, 0x1037 }, { 0x1039, 0x1039 },
+    { 0x1058, 0x1059 }, { 0x1160, 0x11FF }, { 0x135F, 0x135F },
+    { 0x1712, 0x1714 }, { 0x1732, 0x1734 }, { 0x1752, 0x1753 },
+    { 0x1772, 0x1773 }, { 0x17B4, 0x17B5 }, { 0x17B7, 0x17BD },
+    { 0x17C6, 0x17C6 }, { 0x17C9, 0x17D3 }, { 0x17DD, 0x17DD },
+    { 0x180B, 0x180D }, { 0x18A9, 0x18A9 }, { 0x1920, 0x1922 },
+    { 0x1927, 0x1928 }, { 0x1932, 0x1932 }, { 0x1939, 0x193B },
+    { 0x1A17, 0x1A18 }, { 0x1B00, 0x1B03 }, { 0x1B34, 0x1B34 },
+    { 0x1B36, 0x1B3A }, { 0x1B3C, 0x1B3C }, { 0x1B42, 0x1B42 },
+    { 0x1B6B, 0x1B73 }, { 0x1DC0, 0x1DCA }, { 0x1DFE, 0x1DFF },
+    { 0x200B, 0x200F }, { 0x202A, 0x202E }, { 0x2060, 0x2063 },
+    { 0x206A, 0x206F }, { 0x20D0, 0x20EF }, { 0x302A, 0x302F },
+    { 0x3099, 0x309A }, { 0xA806, 0xA806 }, { 0xA80B, 0xA80B },
+    { 0xA825, 0xA826 }, { 0xFB1E, 0xFB1E }, { 0xFE00, 0xFE0F },
+    { 0xFE20, 0xFE23 }, { 0xFEFF, 0xFEFF }, { 0xFFF9, 0xFFFB },
+    { 0x10A01, 0x10A03 }, { 0x10A05, 0x10A06 }, { 0x10A0C, 0x10A0F },
+    { 0x10A38, 0x10A3A }, { 0x10A3F, 0x10A3F }, { 0x1D167, 0x1D169 },
+    { 0x1D173, 0x1D182 }, { 0x1D185, 0x1D18B }, { 0x1D1AA, 0x1D1AD },
+    { 0x1D242, 0x1D244 }, { 0xE0001, 0xE0001 }, { 0xE0020, 0xE007F },
+    { 0xE0100, 0xE01EF }
+  };
+
+  /* test for 8-bit control characters */
+  if (ucs == 0)
+    return 0;
+  if (ucs < 32 || (ucs >= 0x7f && ucs < 0xa0))
+    return -1;
+
+  /* binary search in table of non-spacing characters */
+  if (bisearch(ucs, combining,
+	       sizeof(combining) / sizeof(struct interval) - 1))
+    return 0;
+
+  /* if we arrive here, ucs is not a combining or C0/C1 control character */
+
+  return 1 + 
+    (ucs >= 0x1100 &&
+     (ucs <= 0x115f ||                    /* Hangul Jamo init. consonants */
+      ucs == 0x2329 || ucs == 0x232a ||
+      (ucs >= 0x2e80 && ucs <= 0xa4cf &&
+       ucs != 0x303f) ||                  /* CJK ... Yi */
+      (ucs >= 0xac00 && ucs <= 0xd7a3) || /* Hangul Syllables */
+      (ucs >= 0xf900 && ucs <= 0xfaff) || /* CJK Compatibility Ideographs */
+      (ucs >= 0xfe10 && ucs <= 0xfe19) || /* Vertical forms */
+      (ucs >= 0xfe30 && ucs <= 0xfe6f) || /* CJK Compatibility Forms */
+      (ucs >= 0xff00 && ucs <= 0xff60) || /* Fullwidth Forms */
+      (ucs >= 0xffe0 && ucs <= 0xffe6) ||
+      (ucs >= 0x20000 && ucs <= 0x2fffd) ||
+      (ucs >= 0x30000 && ucs <= 0x3fffd)));
+}
+
+
+int mk_wcswidth(const wchar_t *pwcs, size_t n)
+{
+  int w, width = 0;
+
+  for (;*pwcs && n-- > 0; pwcs++)
+    if ((w = mk_wcwidth(*pwcs)) < 0)
+      return -1;
+    else
+      width += w;
+
+  return width;
+}
+
+
+/*
+ * The following functions are the same as mk_wcwidth() and
+ * mk_wcswidth(), except that spacing characters in the East Asian
+ * Ambiguous (A) category as defined in Unicode Technical Report #11
+ * have a column width of 2. This variant might be useful for users of
+ * CJK legacy encodings who want to migrate to UCS without changing
+ * the traditional terminal character-width behaviour. It is not
+ * otherwise recommended for general use.
+ */
+int mk_wcwidth_cjk(wchar_t ucs)
+{
+  /* sorted list of non-overlapping intervals of East Asian Ambiguous
+   * characters, generated by "uniset +WIDTH-A -cat=Me -cat=Mn -cat=Cf c" */
+  static const struct interval ambiguous[] = {
+    { 0x00A1, 0x00A1 }, { 0x00A4, 0x00A4 }, { 0x00A7, 0x00A8 },
+    { 0x00AA, 0x00AA }, { 0x00AE, 0x00AE }, { 0x00B0, 0x00B4 },
+    { 0x00B6, 0x00BA }, { 0x00BC, 0x00BF }, { 0x00C6, 0x00C6 },
+    { 0x00D0, 0x00D0 }, { 0x00D7, 0x00D8 }, { 0x00DE, 0x00E1 },
+    { 0x00E6, 0x00E6 }, { 0x00E8, 0x00EA }, { 0x00EC, 0x00ED },
+    { 0x00F0, 0x00F0 }, { 0x00F2, 0x00F3 }, { 0x00F7, 0x00FA },
+    { 0x00FC, 0x00FC }, { 0x00FE, 0x00FE }, { 0x0101, 0x0101 },
+    { 0x0111, 0x0111 }, { 0x0113, 0x0113 }, { 0x011B, 0x011B },
+    { 0x0126, 0x0127 }, { 0x012B, 0x012B }, { 0x0131, 0x0133 },
+    { 0x0138, 0x0138 }, { 0x013F, 0x0142 }, { 0x0144, 0x0144 },
+    { 0x0148, 0x014B }, { 0x014D, 0x014D }, { 0x0152, 0x0153 },
+    { 0x0166, 0x0167 }, { 0x016B, 0x016B }, { 0x01CE, 0x01CE },
+    { 0x01D0, 0x01D0 }, { 0x01D2, 0x01D2 }, { 0x01D4, 0x01D4 },
+    { 0x01D6, 0x01D6 }, { 0x01D8, 0x01D8 }, { 0x01DA, 0x01DA },
+    { 0x01DC, 0x01DC }, { 0x0251, 0x0251 }, { 0x0261, 0x0261 },
+    { 0x02C4, 0x02C4 }, { 0x02C7, 0x02C7 }, { 0x02C9, 0x02CB },
+    { 0x02CD, 0x02CD }, { 0x02D0, 0x02D0 }, { 0x02D8, 0x02DB },
+    { 0x02DD, 0x02DD }, { 0x02DF, 0x02DF }, { 0x0391, 0x03A1 },
+    { 0x03A3, 0x03A9 }, { 0x03B1, 0x03C1 }, { 0x03C3, 0x03C9 },
+    { 0x0401, 0x0401 }, { 0x0410, 0x044F }, { 0x0451, 0x0451 },
+    { 0x2010, 0x2010 }, { 0x2013, 0x2016 }, { 0x2018, 0x2019 },
+    { 0x201C, 0x201D }, { 0x2020, 0x2022 }, { 0x2024, 0x2027 },
+    { 0x2030, 0x2030 }, { 0x2032, 0x2033 }, { 0x2035, 0x2035 },
+    { 0x203B, 0x203B }, { 0x203E, 0x203E }, { 0x2074, 0x2074 },
+    { 0x207F, 0x207F }, { 0x2081, 0x2084 }, { 0x20AC, 0x20AC },
+    { 0x2103, 0x2103 }, { 0x2105, 0x2105 }, { 0x2109, 0x2109 },
+    { 0x2113, 0x2113 }, { 0x2116, 0x2116 }, { 0x2121, 0x2122 },
+    { 0x2126, 0x2126 }, { 0x212B, 0x212B }, { 0x2153, 0x2154 },
+    { 0x215B, 0x215E }, { 0x2160, 0x216B }, { 0x2170, 0x2179 },
+    { 0x2190, 0x2199 }, { 0x21B8, 0x21B9 }, { 0x21D2, 0x21D2 },
+    { 0x21D4, 0x21D4 }, { 0x21E7, 0x21E7 }, { 0x2200, 0x2200 },
+    { 0x2202, 0x2203 }, { 0x2207, 0x2208 }, { 0x220B, 0x220B },
+    { 0x220F, 0x220F }, { 0x2211, 0x2211 }, { 0x2215, 0x2215 },
+    { 0x221A, 0x221A }, { 0x221D, 0x2220 }, { 0x2223, 0x2223 },
+    { 0x2225, 0x2225 }, { 0x2227, 0x222C }, { 0x222E, 0x222E },
+    { 0x2234, 0x2237 }, { 0x223C, 0x223D }, { 0x2248, 0x2248 },
+    { 0x224C, 0x224C }, { 0x2252, 0x2252 }, { 0x2260, 0x2261 },
+    { 0x2264, 0x2267 }, { 0x226A, 0x226B }, { 0x226E, 0x226F },
+    { 0x2282, 0x2283 }, { 0x2286, 0x2287 }, { 0x2295, 0x2295 },
+    { 0x2299, 0x2299 }, { 0x22A5, 0x22A5 }, { 0x22BF, 0x22BF },
+    { 0x2312, 0x2312 }, { 0x2460, 0x24E9 }, { 0x24EB, 0x254B },
+    { 0x2550, 0x2573 }, { 0x2580, 0x258F }, { 0x2592, 0x2595 },
+    { 0x25A0, 0x25A1 }, { 0x25A3, 0x25A9 }, { 0x25B2, 0x25B3 },
+    { 0x25B6, 0x25B7 }, { 0x25BC, 0x25BD }, { 0x25C0, 0x25C1 },
+    { 0x25C6, 0x25C8 }, { 0x25CB, 0x25CB }, { 0x25CE, 0x25D1 },
+    { 0x25E2, 0x25E5 }, { 0x25EF, 0x25EF }, { 0x2605, 0x2606 },
+    { 0x2609, 0x2609 }, { 0x260E, 0x260F }, { 0x2614, 0x2615 },
+    { 0x261C, 0x261C }, { 0x261E, 0x261E }, { 0x2640, 0x2640 },
+    { 0x2642, 0x2642 }, { 0x2660, 0x2661 }, { 0x2663, 0x2665 },
+    { 0x2667, 0x266A }, { 0x266C, 0x266D }, { 0x266F, 0x266F },
+    { 0x273D, 0x273D }, { 0x2776, 0x277F }, { 0xE000, 0xF8FF },
+    { 0xFFFD, 0xFFFD }, { 0xF0000, 0xFFFFD }, { 0x100000, 0x10FFFD }
+  };
+
+  /* binary search in table of non-spacing characters */
+  if (bisearch(ucs, ambiguous,
+	       sizeof(ambiguous) / sizeof(struct interval) - 1))
+    return 2;
+
+  return mk_wcwidth(ucs);
+}
+
+
+int mk_wcswidth_cjk(const wchar_t *pwcs, size_t n)
+{
+  int w, width = 0;
+
+  for (;*pwcs && n-- > 0; pwcs++)
+    if ((w = mk_wcwidth_cjk(*pwcs)) < 0)
+      return -1;
+    else
+      width += w;
+
+  return width;
+}
+
+#ifndef NO_USE_UTF8CJK_EMOJI
+/* The following function returns 1 if wide charactor code ucs is
+ * The following functions are the same as mk_wcwidth_cjk() and
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
+
 struct utf8_item {
 	RB_ENTRY(utf8_item)	index_entry;
 	u_int			index;
@@ -229,6 +630,23 @@ utf8_width(struct utf8_data *ud, int *width)
 	case 0:
 		return (UTF8_ERROR);
 	}
+#ifndef NO_USE_UTF8CJK
+	if (options_get_number(global_options, "utf8-cjk")) {
+#ifndef NO_USE_UTF8CJK_EMOJI
+		if (options_get_number(global_options, "utf8-emoji"))
+			*width = mk_wcwidth_cjk_emoji(wc);
+		else
+			*width = mk_wcwidth_cjk(wc);
+#else
+		*width = mk_wcwidth_cjk(wc);
+#endif
+	} else {
+		*width = mk_wcwidth(wc);
+	}
+	log_debug("UTF-8 %.*s, wcwidth() %d", (int)ud->size, ud->data, *width);
+	if (*width >= 0 && *width <= 0xff)
+		return (UTF8_DONE);
+#else
 #ifdef HAVE_UTF8PROC
 	*width = utf8proc_wcwidth(wc);
 #else
@@ -237,6 +655,7 @@ utf8_width(struct utf8_data *ud, int *width)
 	if (*width >= 0 && *width <= 0xff)
 		return (UTF8_DONE);
 	log_debug("UTF-8 %.*s, wcwidth() %d", (int)ud->size, ud->data, *width);
+#endif
 	return (UTF8_ERROR);
 }
 
