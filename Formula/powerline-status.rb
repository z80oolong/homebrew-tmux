class PowerlineStatus < Formula
  include Language::Python::Virtualenv

  desc "Statusline plugin for vim, and provides statuslines and prompts for zsh, tmux and etc."
  homepage "https://powerline.readthedocs.org/en/latest/"

  stable do
    url "https://github.com/powerline/powerline/archive/2.7.tar.gz"
    sha256 "45173a3fd583e60d1c6752b00b67e7f9c342285ec57a57abc1cd6d785d1632c0"
    version "2.7"
  end

  head do
    url "https://github.com/powerline/powerline.git", :revision => "develop"
  end

  depends_on "python@2"
  depends_on "z80oolong/tmux/tmux" => :recommended

  patch :p1, :DATA

  def install
    venv = virtualenv_create(libexec, "python")

    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:", "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name

    venv.pip_install_and_link buildpath
  end

  def caveats; <<~EOS
    To use #{name}, the follow line must be add in #{ENV["HOME"]}/.tmux.conf
    
    ...
    run-shell "#{opt_bin}/powerline-daemon -q"
    source #{opt_libexec}/lib/python2.7/site-packages/powerline/bindings/tmux/powerline.conf
    ...
    EOS
  end
end

__END__
diff --git a/powerline/bindings/tmux/__init__.py b/powerline/bindings/tmux/__init__.py
index 011cd689..26cc7dfd 100644
--- a/powerline/bindings/tmux/__init__.py
+++ b/powerline/bindings/tmux/__init__.py
@@ -78,7 +78,11 @@ def get_tmux_version(pl):
 	version_string = version_string.strip()
 	if version_string == 'master':
 		return TmuxVersionInfo(float('inf'), 0, version_string)
-	major, minor = version_string.split('.')
-	suffix = DIGITS.subn('', minor)[0] or None
-	minor = NON_DIGITS.subn('', minor)[0]
-	return TmuxVersionInfo(int(major), int(minor), suffix)
+	try:
+		major, minor = version_string.split('.')
+		suffix = DIGITS.subn('', minor)[0] or None
+		minor = NON_DIGITS.subn('', minor)[0]
+		return TmuxVersionInfo(int(major), int(minor), suffix)
+	except:
+		# If version_string == "next-2.9", and etc., then version of tmux is 'master'.
+		return TmuxVersionInfo(float('inf'), 0, version_string)
