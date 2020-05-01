class AppimageTmux < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "3.1a"
  appimage_version = "v3.1a-eaw-appimage-0.1.0"
  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
  sha256 "cbecae2a50cacdb5d0ec84c105f80ce97dfedbb466c53e5ec1dff2f0010843e3"
  version tmux_version
  revision 4

  head do
    tmux_version = "HEAD-5af69439"
    url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
    sha256 "0c1240ffc745f0945eba9263ec81399a65241ac6c125c30358670975fdcf2c5e"
    version tmux_version
  end

  keg_only "This formula is conflict with z80oolong/tmux/tmux."

  option "with-extract", "Extract tmux AppImage."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    tmux_version = build.head? ? "HEAD-f986539e" : version

    (buildpath/"tmux-eaw-#{tmux_version}-x86_64.AppImage").chmod(0755)

    if build.with?("extract") then
      libexec.mkdir; bin.mkdir

      libexec.cd do
        system "#{buildpath}/tmux-eaw-#{tmux_version}-x86_64.AppImage", "--appimage-extract"
      end
      inreplace (libexec/"squashfs-root/AppRun").to_s, /^#export APPDIR=.*$/, %{export APPDIR="#{libexec}/squashfs-root"}

      (bin/"tmux").make_symlink (libexec/"squashfs-root/AppRun")
    else
      bin.install "#{buildpath}/tmux-eaw-#{tmux_version}-x86_64.AppImage" => "tmux"
    end

    bash_completion.install resource("completion")
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
