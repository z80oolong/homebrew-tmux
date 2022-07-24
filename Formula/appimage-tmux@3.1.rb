class AppimageTmuxAT31 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.4/tmux-eaw-3.1-x86_64.AppImage"
  sha256 "30f4cc67d090d2a3f840bf65f781c23e4503b06287841e23b886c9d475f6cb00"
  version "3.1"
  revision 41

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.1-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.1-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.1-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.1-x86_64.AppImage") => "tmux"
    end
  end
end
