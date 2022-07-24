class AppimageTmuxAT30 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.4/tmux-eaw-3.0-x86_64.AppImage"
  sha256 "cf311cbcdf7162edb20698c1e4c1bc50be75dea43f2d793c99f9533c4b3c4c4e"
  version "3.0"
  revision 41

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.0-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.0-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.0-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.0-x86_64.AppImage") => "tmux"
    end
  end
end
