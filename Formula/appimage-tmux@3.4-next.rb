class AppimageTmuxAT34Next < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.3a-eaw-appimage-0.1.0/tmux-eaw-HEAD-67960dcc-x86_64.AppImage"
  sha256 "ce7fb3db28e50e9e0a988d4676ccbc6cc6bf359bcd6726e2f7ac725431644b19"
  version "HEAD-67960dcc"
  revision 37

  keg_only :versioned_formula

  option "with-extract", "Extract appimagetool AppImage."

  def install
    (buildpath/"tmux-eaw-HEAD-67960dcc-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-HEAD-67960dcc-x86_64.AppImage", "--appimage-extract"
      end
      bin.install_symlink (libexec/"squashfs-root/AppRun") => "tmux"
    else
      (libexec/"bin").mkpath
      (libexec/"bin").install "#{buildpath}/tmux-eaw-HEAD-67960dcc-x86_64.AppImage"
      bin.install_symlink (libexec/"bin/tmux-eaw-HEAD-67960dcc-x86_64.AppImage") => "tmux"
    end
  end
end
