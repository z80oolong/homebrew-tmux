class AppimageTmuxAT30a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.0a-x86_64.AppImage"
  sha256 "8cd03c82a5b21a3b0978bf510c4838e917f1f9980f42525c3091c7c8715c5dd3"
  version "3.0a"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.0a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.0a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.0a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.0a-x86_64.AppImage") => "tmux"
    end
  end
end
