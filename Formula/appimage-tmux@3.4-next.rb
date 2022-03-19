class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.2a-eaw-appimage-0.5.1/tmux-eaw-HEAD-ee3f1d25-x86_64.AppImage"
  sha256 "7dd58c45ff45c1cd1895ca1b5e66a9a746d20517b9f9fac875fea7d6d51cebd0"
  version "HEAD-ee3f1d25"
  revision 32

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-ee3f1d25-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-ee3f1d25-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-ee3f1d25-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-ee3f1d25-x86_64.AppImage") => "tmux"
    end
  end
end