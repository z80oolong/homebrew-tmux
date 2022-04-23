class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-HEAD-58d1a206-x86_64.AppImage"
  sha256 "a474de499c36f7cfe540c026e909a412423c58e5fb5188798f903b0a84ae205e"
  version "HEAD-58d1a206"
  revision 36

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-58d1a206-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-58d1a206-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-58d1a206-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-58d1a206-x86_64.AppImage") => "tmux"
    end
  end
end
