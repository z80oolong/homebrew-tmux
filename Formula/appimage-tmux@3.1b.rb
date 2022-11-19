class AppimageTmuxAT31b < Formula
  desc "Formula to install AppImage tmux-eaw-3.1b-x86_64.AppImage, generated by `brew appimage-install` command."
  homepage "https://github.com/z80oolong/tmux-eaw-appimage/releases/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.1b_50/tmux-eaw-3.1b-x86_64.AppImage"
  sha256 "b02e61e22d555367165532714ef29cf73c931ea1a468895131c9b93d0adb0a4d"
  version "3.1b"
  revision 50

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.1b-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.1b-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.1b-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.1b-x86_64.AppImage") => "tmux"
    end
  end
end
