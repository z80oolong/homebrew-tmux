class AppimageTmuxAT31b < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.1b-x86_64.AppImage"
  sha256 "bdf219b757423a015fe52159c5c165efe52391a935f56fbaa6c398baf237fbea"
  version "3.1b"
  revision 35

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
