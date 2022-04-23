class AppimageTmuxAT33 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-3.3-rc-x86_64.AppImage"
  sha256 "ad14933dab59467c26b91bfdf80a7055dccf8064cc4c4bb50fcb7c3b218bcad8"
  version "3.3-rc"
  revision 36

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.3-rc-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.3-rc-x86_64.AppImage") => "tmux"
    end
  end
end
