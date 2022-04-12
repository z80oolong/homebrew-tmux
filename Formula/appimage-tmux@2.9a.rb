class AppimageTmuxAT29a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-2.9a-x86_64.AppImage"
  sha256 "9fcea7fd653cdd25295f8a6899a4e8e7cc8b5b1a265c006b6b6019f4c8b82b07"
  version "2.9a"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-2.9a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-2.9a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-2.9a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-2.9a-x86_64.AppImage") => "tmux"
    end
  end
end
