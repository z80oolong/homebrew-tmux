class AppimageTmuxAT32a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-3.2a-x86_64.AppImage"
  sha256 "8399e4930f77e05dbef322d47aec567b046e7c1e4c6361d424425c2c8724c33f"
  version "3.2a"
  revision 36

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.2a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.2a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.2a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.2a-x86_64.AppImage") => "tmux"
    end
  end
end
