class TmuxResurrect < Formula
  desc "Persists tmux environment across system restarts"
  homepage "https://github.com/tmux-plugins/tmux-resurrect"
  url "https://github.com/tmux-plugins/tmux-resurrect/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "f8559d86d81be769054d63b28a268229a09bc6cc311f0623656c3090ec781b76"
  license "MIT"
  head "https://github.com/tmux-plugins/tmux-resurrect.git", revision: "master"

  keg_only "`tmux-resurrect` is tmux plugin"

  depends_on "z80oolong/tmux/tmux"

  def install
    ohai "Clean #{libexec}, #{share}"
    rm_r libexec.glob("*")
    rm_r share.glob("*")

    ohai "Install #{buildpath}/docs => #{share}/#{name}/docs"
    (share/name.to_s).install buildpath/"docs"

    ohai "Install #{buildpath}/videos => #{share}/#{name}/video"
    (share/name.to_s).install buildpath/"video"

    ohai "Install #{buildpath}/*.md => #{share}/#{name}/docs/*.md"
    (share/"#{name}/docs").install buildpath.glob("*.md")

    ohai "Install #{buildpath}/* => #{libexec}/#{name}/*"
    (libexec/name.to_s).install buildpath.glob("*")
  end

  def caveats
    <<~EOS
      To use #{name} in tmux, add this to your tmux configuration file
      (#{Dir.home}/.tmux.conf or #{Dir.home}/.config/tmux/tmux.conf):
        ...
        run-shell '#{opt_libexec}/#{name}/resurrect.tmux'
        ...
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_empty shell_output(libexec/"#{name}/resurrect.tmux")
  end
end
