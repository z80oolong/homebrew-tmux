class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-HEAD-b0ff4467-x86_64.AppImage"
  sha256 "6838384c2360602e4875649ee80511ccd07d6242eb1d9cf1c9e9164fe1328d48"
  version "HEAD-b0ff4467"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-b0ff4467-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-b0ff4467-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-b0ff4467-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-b0ff4467-x86_64.AppImage") => "tmux"
    end
  end
end
