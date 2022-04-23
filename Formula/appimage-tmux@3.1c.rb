class AppimageTmuxAT31c < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.6.1/tmux-eaw-3.1c-x86_64.AppImage"
  sha256 "524bdf8a739a67aa9153f3b49c8a1881926d346e9586edec0696e838e2525227"
  version "3.1c"
  revision 36

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
