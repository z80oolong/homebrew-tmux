class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.4/tmux-eaw-HEAD-9d9445a4-x86_64.AppImage"
  sha256 "a6ee42ff2e139677d8774c77a26a72ec52eca81f0391337e78d3d802c2b35470"
  version "HEAD-9d9445a4"
  revision 41

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-9d9445a4-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-9d9445a4-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-9d9445a4-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-9d9445a4-x86_64.AppImage") => "tmux"
    end
  end
end
