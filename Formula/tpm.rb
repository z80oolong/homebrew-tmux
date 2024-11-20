class Tpm < Formula
  desc "Tmux Plugin Manager"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2411fc416c4475d297f61078d0a03afb3a1f5322fff26a13fdb4f20d7e975570"
  head "https://github.com/tmux-plugins/tpm.git"

  depends_on "bash" => :optional
  depends_on "git"  => :optional
  depends_on "tmux" => :optional
  depends_on "z80oolong/tmux/tmux" => :optional

  def install
    Pathname.glob(buildpath/"*") { |path| (libexec/"tpm").install(path) unless %r{^.*/\.git/.*}.match?(path.to_s) }
  end

  def caveats
    <<~EOS
      To use #{name}, modify the bottom of #{Dir.home}/.tmux.conf, etc:

      for example:
      ...
      run -b "#{opt_libexec}/tpm/tpm"
      ...
    EOS
  end
end
