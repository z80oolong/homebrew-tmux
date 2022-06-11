class AppimageTmuxAT31c < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.0/tmux-eaw-3.1c-x86_64.AppImage"
  sha256 "0e5db716587a2d886b148f62335a8a3c59d73e1e631bf0b633784aa42c3567f2"
  version "3.1c"
  revision 37

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.1c-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.1c-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.1c-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.1c-x86_64.AppImage") => "tmux"
    end
  end
end
