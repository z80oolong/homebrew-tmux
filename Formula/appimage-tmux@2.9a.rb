class AppimageTmuxAT29a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-2.9a-x86_64.AppImage"
  sha256 "ba64eefc3c16ed822003a41898c24d1e21ce6bf1e7fd53f0b3dc148770d215de"
  version "2.9a"
  revision 36

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
