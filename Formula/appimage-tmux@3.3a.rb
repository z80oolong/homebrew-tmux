class AppimageTmuxAT33a < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.0/tmux-eaw-3.3a-x86_64.AppImage"
  sha256 "148319aa1e4cb57f904f4450eeeb04266b974a9c048d339960a3524c785799cb"
  version "3.3a"
  revision 37

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.3a-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.3a-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.3a-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.3a-x86_64.AppImage") => "tmux"
    end
  end
end
