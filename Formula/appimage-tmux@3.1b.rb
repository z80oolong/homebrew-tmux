class AppimageTmuxAT31b < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.5.0/tmux-eaw-3.1b-x86_64.AppImage"
  sha256 "e6e5fe56e07552c43c20167900c0e7cd6689b78f07ed3f7d9a9ee8e16a60bcce"
  version "3.1b"
  revision 31

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
