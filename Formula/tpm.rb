class Tpm < Formula
  desc "Tmux Plugin Manager"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/v3.1.0.tar.gz"
  version "3.1.0"
  sha256 "2411fc416c4475d297f61078d0a03afb3a1f5322fff26a13fdb4f20d7e975570"
  head "https://github.com/tmux-plugins/tpm.git"

  depends_on "tmux" => :optional
  depends_on "git"  => :optional
  depends_on "bash" => :optional

  def install
    Pathname.glob(buildpath/"*") {|path| (libexec/"tpm").install(path) unless (%r[^.*/\.git/.*] === path.to_s)}
  end

  def caveats; <<~EOS
    To use #{name}, modify the bottom of #{ENV["HOME"]}/.tmux.conf:
    
    for example:
    ...
    run -b "#{opt_libexec}/tpm/tpm"
    ...
    EOS
  end
end
