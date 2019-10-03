class Tpm < Formula
  desc "Tmux Plugin Manager"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/v3.0.0.tar.gz"
  version "3.0.0"
  sha256 "65093ca3995d9ac3889bc7630e11667e7156051d3da85526e28d53eeb29e7002"
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
