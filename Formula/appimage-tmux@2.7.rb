class AppimageTmuxAT27 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-2.7-x86_64.AppImage"
  sha256 "b8ef4856b155bc1301f503df94573f37ff4baa7a962e87cb979ae4f0ed777c15"
  version "2.7"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-2.7-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-2.7-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-2.7-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-2.7-x86_64.AppImage") => "tmux"
    end
  end
end
