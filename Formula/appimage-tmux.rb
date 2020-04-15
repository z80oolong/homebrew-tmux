class AppimageTmux < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "3.0a"
  appimage_version = "v3.0a-eaw-appimage-0.2.0"
  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
  sha256 "b6f91e7662ed11529c9e2b09ad419a60082e99528857f6d1f687bf0633300f52"
  version tmux_version
  revision 2

  devel do
    tmux_version = "3.1-rc4"
    url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
    sha256 "0ab403d4ffc22dae65357f219d21c13bce23f27bb93cc9372af4b22d411a8dcc"
    version tmux_version
  end

  head do
    tmux_version = "HEAD-b117c3b8"
    url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/#{appimage_version}/tmux-eaw-#{tmux_version}-x86_64.AppImage"
    sha256 "67e6cc1ee5506f962c94c5452532a6a28943911664b69c8dde8cc1a5b593138e"
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
