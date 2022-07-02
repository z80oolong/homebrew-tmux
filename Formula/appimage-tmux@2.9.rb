class AppimageTmuxAT29 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.2/tmux-eaw-2.9-x86_64.AppImage"
  sha256 "2f3b40b95435b051057960bace816746d1074703cb365a493360f6d6b6be4cd6"
  version "2.9"
  revision 39

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-2.9-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-2.9-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-2.9-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-2.9-x86_64.AppImage") => "tmux"
    end
  end
end
