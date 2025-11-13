class PowerlineStatusAT283 < Formula
  include Language::Python::Virtualenv

  desc "Statusline plugin provides statuslines and prompts for tmux and etc."
  homepage "https://powerline.readthedocs.io/en/latest/"
  url "https://github.com/powerline/powerline/archive/refs/tags/2.8.3.tar.gz"
  sha256 "45d838dbac94a1363942899708b6ce7c71c1cad9e1b9d048affab4f630c4cb98"
  revision 1

  keg_only :versioned_formula

  depends_on "z80oolong/fonts/umefont"
  depends_on "z80oolong/fonts/vlgothic"
  depends_on "python@3.10" => :recommended
  depends_on "neovim" => :optional
  depends_on "vim" => :optional
  depends_on "z80oolong/tmux/tmux" => :optional

  if build.without?("python@3.10")
    resource("appimage-python3.10") do
      url "https://github.com/niess/python-appimage/releases/download/python3.10/python3.10.7-cp310-cp310-manylinux2014_x86_64.AppImage"
      sha256 "bbed4dbcc465c2930a32cd5fc2f853e632d1ba3b75590e5d0d7c07d30e71d4bf"
    end
  end

  patch :p1, :DATA

  def install
    libexec.mkdir
    bin.mkdir

    if build.without?("python@3.10")
      resource("appimage-python3.10").stage do
        (Pathname.pwd/"python3.10.7-cp310-cp310-manylinux2014_x86_64.AppImage").chmod(0755)
        system "./python3.10.7-cp310-cp310-manylinux2014_x86_64.AppImage", "--appimage-extract"
        libexec.install "./squashfs-root"
      end

      system libexec/"squashfs-root/usr/bin/python3.10", libexec/"squashfs-root/usr/bin/pip", "install",
        "-v", "--no-binary", ":all:", "--ignore-installed", buildpath
    else
      venv = virtualenv_create(libexec, "python3", without_pip: false)

      system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:", "--ignore-installed", buildpath
      system libexec/"bin/pip", "uninstall", "-y", name

      venv.pip_install_and_link buildpath
    end

    (share/"powerline").mkpath
    if build.without?("python@3.10")
      install_symlink_recurse (share/"powerline"),
        (libexec/"squashfs-root/opt/python3.10/lib/python3.10/site-packages/powerline/bindings")
      install_symlink_recurse (share/"powerline"),
        (libexec/"squashfs-root/opt/python3.10/lib/python3.10/site-packages/powerline/config_files")

      bin.install_symlink libexec/"squashfs-root/opt/python3.10/bin/powerline"
      bin.install_symlink libexec/"squashfs-root/opt/python3.10/bin/powerline-daemon"
      bin.install_symlink libexec/"squashfs-root/opt/python3.10/bin/powerline-config"
      bin.install_symlink libexec/"squashfs-root/opt/python3.10/bin/powerline-render"
      bin.install_symlink libexec/"squashfs-root/opt/python3.10/bin/powerline-lint"
    else
      install_symlink_recurse share/"powerline", libexec/"lib/python3.10/site-packages/powerline/bindings"
      install_symlink_recurse share/"powerline", libexec/"lib/python3.10/site-packages/powerline/config_files"
    end
  end

  def install_symlink_recurse(dst, src)
    ohai "Install symlink #{src} -> #{dst}"

    if src.directory? || (dst == (share/"powerline"))
      src_base = src.basename
      dst_dir = dst/src_base
      dst_dir.mkpath
      src.each_child { |s| install_symlink_recurse(dst_dir, s) }
    else
      dst.install_symlink src
    end
  end

  def caveats
    <<~EOS
      To use #{name} in tmux, add the following line to the configuration file `#{Dir.home}/.tmux.conf, #{Dir.home}/.config/tmux/tmux.conf, etc.`.

      ...
      run-shell "#{opt_bin}/powerline-daemon -q"
      source #{opt_share}/powerline/bindings/tmux/powerline.conf
      ...
    EOS
  end
end

__END__
diff --git a/powerline/bindings/tmux/__init__.py b/powerline/bindings/tmux/__init__.py
index eb84e7a..8f5cb4f 100644
--- a/powerline/bindings/tmux/__init__.py
+++ b/powerline/bindings/tmux/__init__.py
@@ -78,8 +78,12 @@ def get_tmux_version(pl):
 	version_string = version_string.strip()
 	if version_string == 'master':
 		return TmuxVersionInfo(float('inf'), 0, version_string)
-	major, minor = version_string.split('.')
-	major = NON_DIGITS.subn('', major)[0]
-	suffix = DIGITS.subn('', minor)[0] or None
-	minor = NON_DIGITS.subn('', minor)[0]
-	return TmuxVersionInfo(int(major), int(minor), suffix)
+	try:
+		major, minor = version_string.split('.')
+		major = NON_DIGITS.subn('', major)[0]
+		suffix = DIGITS.subn('', minor)[0] or None
+		minor = NON_DIGITS.subn('', minor)[0]
+		return TmuxVersionInfo(int(major), int(minor), suffix)
+	except:
+		# If version_string == "next-2.9", and etc., then version of tmux is 'master'.
+		return TmuxVersionInfo(float('inf'), 0, version_string)
