class AppimageTmuxAT33 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.5.0/tmux-eaw-3.3-rc-x86_64.AppImage"
  sha256 "b0d08eac1536dad7161b2fabf976c18c2a78674b1c2458f617348cad37d66fd2"
  version "3.3-rc"
  revision 31

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-3.3-rc-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-3.3-rc-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-3.3-rc-x86_64.AppImage") => "tmux"
    end
  end
end
