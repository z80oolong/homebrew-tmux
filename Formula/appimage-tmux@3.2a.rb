class AppimageTmuxAT32a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.5.1/tmux-eaw-3.2a-x86_64.AppImage"
  sha256 "453e89a43757f6d2e70752c68c704194f0409d13a2966dad55ef5b9cef1980a9"
  version "3.2a"
  revision 32

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
