class AppimageTmuxAT31c < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.0/tmux-eaw-3.1c-x86_64.AppImage"
  sha256 "8db4523540e79152f14a011c50eb713e29e5365f5168fe14e8d22a9ff2cf859f"
  version "3.1c"
  revision 35

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.1c-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.1c-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.1c-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.1c-x86_64.AppImage") => "tmux"
    end
  end
end
