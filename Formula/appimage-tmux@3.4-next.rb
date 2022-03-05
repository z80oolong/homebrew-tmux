class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.5.0/tmux-eaw-HEAD-60688afe-x86_64.AppImage"
  sha256 "9cc7e9b3d6e8574c6dc776127236f07b1e0a72830aa92adfedcee96b070d7ede"
  version "HEAD-60688afe"
  revision 31

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-60688afe-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-60688afe-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-60688afe-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-60688afe-x86_64.AppImage") => "tmux"
    end
  end
end
