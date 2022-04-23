class AppimageTmuxAT30a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-3.0a-x86_64.AppImage"
  sha256 "94fc0d4938d634d69bda765cf5cbaace6e360b4e27f0d541a346c2e9f8c8db78"
  version "3.0a"
  revision 36

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.0a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.0a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.0a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.0a-x86_64.AppImage") => "tmux"
    end
  end
end
