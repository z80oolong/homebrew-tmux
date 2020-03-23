class AppimageTmux < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  tmux_version = "3.0a"
  url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.0a-eaw-appimage-0.1.1/tmux-eaw-#{tmux_version}-x86_64.AppImage"
  sha256 "a3b221d95820a4689c0ba43898e896839353523c882063748a0ba8c1d09a4313"
  version tmux_version

  devel do
    tmux_version = "3.1-rc3"
    url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.0a-eaw-appimage-0.1.1/tmux-eaw-#{tmux_version}-x86_64.AppImage"
    sha256 "4b2672573765681d93ee7081f501e5d56599eeafa3992d6c05134e4248e4c1f4"
    version tmux_version
  end

  head do
    tmux_version = "HEAD-5b71943f"
    url "https://github.com/z80oolong/tmux-eaw-appimage/releases/download/v3.0a-eaw-appimage-0.1.1/tmux-eaw-#{tmux_version}-x86_64.AppImage"
    sha256 "17541dca6aabbd2a0e247845323909a16b8b4aabb8b9f9eb2c8c0d38e6308224"
    version tmux_version
  end

  keg_only "This formula is conflict with z80oolong/tmux/tmux."

  option "with-extract", "Extract tmux AppImage."

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    tmux_version = build.head? ? "HEAD-5b71943f" : version

    (buildpath/"tmux-eaw-#{tmux_version}-x86_64.AppImage").chmod(0755)

    if build.with?("extract") then
      libexec.mkdir; bin.mkdir

      libexec.cd do
        system "#{buildpath}/tmux-eaw-#{tmux_version}-x86_64.AppImage", "--appimage-extract"
      end

      (bin/"tmux").make_symlink (libexec/"squashfs-root/usr/bin/tmux")
    else
      bin.install "#{buildpath}/tmux-eaw-#{tmux_version}-x86_64.AppImage" => "tmux"
    end

    bash_completion.install resource("completion")
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
