class AppimageTmuxAT26 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "2.6"
  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.0a-eaw-appimage-0.1.2/tmux-eaw-#{tmux_version}-x86_64.AppImage"
  sha256 "cad24379b6f5e7413da601c48d5f949726b59b173e67455f8ec3ac40f6c9a09a"
  version tmux_version
  revision 1

  keg_only :versioned_formula

  option "with-extract", "Extract tmux AppImage."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    (buildpath/"tmux-eaw-#{version}-x86_64.AppImage").chmod(0755)

    if build.with?("extract") then
      libexec.mkdir; bin.mkdir

      libexec.cd do
        system "#{buildpath}/tmux-eaw-#{version}-x86_64.AppImage", "--appimage-extract"
      end
      inreplace (libexec/"squashfs-root/AppRun").to_s, /^#export APPDIR=.*$/, %{export APPDIR="#{libexec}/squashfs-root"}

      (bin/"tmux").make_symlink (libexec/"squashfs-root/AppRun")
    else
      bin.install "#{buildpath}/tmux-eaw-#{version}-x86_64.AppImage" => "tmux"
    end

    bash_completion.install resource("completion")
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
