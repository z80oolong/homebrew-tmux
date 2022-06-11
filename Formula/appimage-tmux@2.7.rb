class AppimageTmuxAT27 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.0/tmux-eaw-2.7-x86_64.AppImage"
  sha256 "1eea25d2611a36302ee2a2bc1319d2a4816a3cfe2b670bd5de890a139fb0aa69"
  version "2.7"
  revision 37

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
