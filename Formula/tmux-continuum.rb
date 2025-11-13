class TmuxContinuum < Formula
  desc "Continuous saving of tmux environment, and automatic restore when tmux is started."
  homepage "https://github.com/tmux-plugins/tmux-continuum"
  url "https://github.com/tmux-plugins/tmux-continuum/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "311dddeebbf7b803cd19c339ab887784b715fd8ef206ec430028cabb8574de87"
  license "MIT"
  head "https://github.com/tmux-plugins/tmux-continuum.git", revision: "master"

  keg_only "`tmux-continuum` is tmux plugin"

  depends_on "z80oolong/tmux/tmux-resurrect"
  depends_on "z80oolong/tmux/tmux" => :optional

  def install
    ohai "Install #{buildpath}/* => #{libexec}/*"
    libexec.install buildpath.glob("*")
  end

  def caveats
    <<~EOS
      To use #{name} in tmux, add the following line to the configuration file
      `#{Dir.home}/.tmux.conf, #{Dir.home}/.config/tmux/tmux.conf, etc.`.

      ...
      run-shell "#{Formula["z80oolong/tmux/tmux-resurrect"].opt_libexec}/resurrect.tmux"
      run-shell "#{opt_libexec}/continuum.tmux"
      ...
    EOS
  end

  test do
    system "false"
  end
end
