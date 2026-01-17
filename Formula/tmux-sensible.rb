class TmuxSensible < Formula
  desc "Persists tmux environment across system restarts"
  homepage "https://github.com/tmux-plugins/tmux-sensible"
  url "https://github.com/tmux-plugins/tmux-sensible/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "426dcf398d3073bb526db88921ff5734e5566a045b23c8194cb3646646f61c16"
  license "MIT"
  head "https://github.com/tmux-plugins/tmux-sensible.git", revision: "master"

  keg_only "`tmux-sensible` is tmux plugin"

  depends_on "z80oolong/tmux/tmux"
p $:
  def install
    ohai "Clean #{libexec}, #{share}"
    rm_r libexec.glob("*")
    rm_r share.glob("*")

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
        run-shell '#{opt_libexec}/#{name}/sensible.tmux'
        ...
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_empty shell_output(libexec/"#{name}/sensible.tmux")
  end
end
