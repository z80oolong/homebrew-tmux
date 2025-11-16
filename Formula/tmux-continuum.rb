class TmuxContinuum < Formula
  desc "Continuous saving of tmux environment, automatic restore when tmux is started"
  homepage "https://github.com/tmux-plugins/tmux-continuum"
  url "https://github.com/tmux-plugins/tmux-continuum/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "311dddeebbf7b803cd19c339ab887784b715fd8ef206ec430028cabb8574de87"
  license "MIT"
  head "https://github.com/tmux-plugins/tmux-continuum.git", revision: "master"

  keg_only "`tmux-continuum` is tmux plugin"

  depends_on "z80oolong/tmux/tmux"
  depends_on "z80oolong/tmux/tmux-resurrect"

  def install
    ohai "Clean #{libexec}, #{share}"
    rm_r libexec.glob("*")
    rm_r share.glob("*")

    ohai "Install #{buildpath}/docs => #{share}/#{name}/docs"
    (share/name.to_s).install buildpath/"docs"

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
        run-shell '#{opt_libexec}/#{name}/continuum.tmux'
        ...
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_empty shell_output("#{libexec}/#{name}/continuum.tmux 2> /dev/null")
  end
end
