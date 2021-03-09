class AppimageTmuxAT26 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "2.6"
  appimage_version = "v3.1c-eaw-appimage-0.1.8"
  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
  sha256 "5baf8f3a2ac68e0ee0f9727e61749c1cc15549c3c6fc998f4906a67fc0442f53"
  version tmux_version
  revision 16

  keg_only :versioned_formula

  option "with-extract", "Extract tmux AppImage."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    (buildpath/"tmux-eaw-#{version}-x86_64.AppImage").chmod(0755)
    bin.mkdir; libexec.mkdir

    if build.with?("extract") then
      libexec.cd do
        system "#{buildpath}/tmux-eaw-#{version}-x86_64.AppImage", "--appimage-extract"
      end
      inreplace (libexec/"squashfs-root/AppRun").to_s, /^#export APPDIR=.*$/, %{export APPDIR="#{libexec}/squashfs-root"}

      (bin/"tmux").make_symlink (libexec/"squashfs-root/AppRun")
    else
      libexec.install "#{buildpath}/tmux-eaw-#{version}-x86_64.AppImage"
      (bin/"tmux").make_symlink (libexec/"tmux-eaw-#{version}-x86_64.AppImage")
    end

    bash_completion.install resource("completion")
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
