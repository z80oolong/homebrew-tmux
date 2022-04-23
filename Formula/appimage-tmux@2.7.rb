class AppimageTmuxAT27 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-2.7-x86_64.AppImage"
  sha256 "46ac950cc29a5c538a68d5c97d73f7f59ec638267a43a2f63de1ef87f1ced3ad"
  version "2.7"
  revision 36

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
