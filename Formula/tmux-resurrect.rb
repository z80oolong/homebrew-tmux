class TmuxResurrect < Formula
  desc "Persists tmux environment across system restarts."
  homepage "https://github.com/tmux-plugins/tmux-resurrect"
  url "https://github.com/tmux-plugins/tmux-resurrect/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "f8559d86d81be769054d63b28a268229a09bc6cc311f0623656c3090ec781b76"
  license "MIT"
  head "https://github.com/tmux-plugins/tmux-resurrect.git", revision: "master"

  keg_only "`tmux-resurrect` is tmux plugin"

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
      run-shell "#{opt_libexec}/resurrect.tmux"
      ...
    EOS
  end

  test do
    system "false"
  end
end
