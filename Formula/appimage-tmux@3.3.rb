class AppimageTmuxAT33 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.3-rc-x86_64.AppImage"
  sha256 "f7ab5954d3cf473151f42d1fe30c278932837fea3b9bfd56314f80b3d60cc422"
  version "3.3-rc"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.3-rc-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.3-rc-x86_64.AppImage") => "tmux"
    end
  end
end
