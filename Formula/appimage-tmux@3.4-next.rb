class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.2/tmux-eaw-HEAD-f08c019d-x86_64.AppImage"
  sha256 "760fccb99b267a023b6c4bbd4abc475313d3b41d75bf35596134e313690698ea"
  version "HEAD-f08c019d"
  revision 39

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-f08c019d-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-f08c019d-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-f08c019d-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-f08c019d-x86_64.AppImage") => "tmux"
    end
  end
end
