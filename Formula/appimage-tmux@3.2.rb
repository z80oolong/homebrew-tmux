class AppimageTmuxAT32 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.0/tmux-eaw-3.2-x86_64.AppImage"
  sha256 "9084a1bf6375007e5fd921db847473452153e29cc793e6fe8d98c6ccde0b56d8"
  version "3.2"
  revision 37

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
