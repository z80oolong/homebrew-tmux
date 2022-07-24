class AppimageTmuxAT31b < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.4/tmux-eaw-3.1b-x86_64.AppImage"
  sha256 "52f42dc208da24f36f095172ec32482fc8372c5029e95caed43d50a9c12bc14d"
  version "3.1b"
  revision 41

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
