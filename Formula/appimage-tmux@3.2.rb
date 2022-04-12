class AppimageTmuxAT32 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.2-x86_64.AppImage"
  sha256 "0026472d6a5539ec746a60ad50f9cd79b01f544547b9a52864f8b0cf955f9f40"
  version "3.2"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.2-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.2-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.2-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.2-x86_64.AppImage") => "tmux"
    end
  end
end
