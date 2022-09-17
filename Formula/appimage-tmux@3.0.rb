class AppimageTmuxAT30 < Formula
  desc "Formula to install AppImage tmux-eaw-3.0-x86_64.AppImage, generated by `brew appimage-install` command."
  homepage "file:///vagrant/opt/releases/tmux-eaw-3.0-x86_64.AppImage"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.5/tmux-eaw-3.0-x86_64.AppImage"
  sha256 "460ac604c1886aab1fbd23fd426750fb70306c3a5cfd3f3155e06eb5a8f69953"
  version "3.0"
  revision 42

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.0-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.0-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.0-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.0-x86_64.AppImage") => "tmux"
    end
  end
end
