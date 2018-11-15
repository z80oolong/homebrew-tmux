class PowerlineFonts < Formula
  desc "Fonts for powerline."
  homepage "https://github.com/powerline/fonts"

  url "https://github.com/powerline/fonts/archive/2015-12-04.tar.gz"
  sha256 "3a0b73abca6334b5e6bddefab67f6eb1b2fac1231817d95fc79126c8998c4844"
  version "20151204.0"
  head "https://github.com/powerline/fonts.git"

  depends_on "fontconfig" => [:build, :recommended]
  depends_on "z80oolong/tmux/powerline-status" => :recommended

  def install
    (share/"fonts").mkpath
    inreplace "./install.sh", %{font_dir="$HOME/.local/share/fonts"}, %{font_dir="#{share}/fonts"}

    system "./install.sh"
  end

  def post_install
    home_fonts = Pathname.new("#{ENV["HOME"]}/.local/share/fonts/#{name}")
    home_fonts.mkpath

    home_fonts.cd do
      (opt_share/"fonts").find do |font|
        if /^.*\.([ot]tf|pcf\.gz)$/ === "#{font}" then system "ln", "-sf", "#{font}", "." end
      end
    end

    system "fc-cache", "-vf", "#{ENV["HOME"]}/.local/share/fonts"
  end

  test do
    system "fc-list"
  end
end
