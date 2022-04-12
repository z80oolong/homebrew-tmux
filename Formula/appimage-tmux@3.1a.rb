class AppimageTmuxAT31a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.1a-x86_64.AppImage"
  sha256 "7cb97212fc1f7385e2f3d4e63fa96a95853b08930d1894ff72dfe64141e5f092"
  version "3.1a"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.1a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.1a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.1a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.1a-x86_64.AppImage") => "tmux"
    end
  end
end
