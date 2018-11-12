class GotBin < Formula
  desc "Simple tmux tool with go -- installed with binary code."
  homepage "https://github.com/skanehira/got/"
  version "1.0.2"

  depends_on "z80oolong/tmux/tmux" => :recommended

  # `got` binary file is x86-64 architecture only.
  if Hardware::CPU.is_32_bit? then
    raise "This formula can't use for this architecture. use `brew install z80oolong/tmux/got-src` and `brew link --force got-src`."
  end

  if OS.linux? then
    url "https://github.com/skanehira/got/releases/download/v1.0.2/Linux.zip"
    sha256 "5d08ac339a0e3a831c1518542d203030db9ebb1ac76a8cc141fedc122cba726e"
  else
    url "https://github.com/skanehira/got/releases/download/v1.0.2/MacOS.zip"
    sha256 "9e8b503e8093caed5f3330d697d6f92cc2d603e9bb6875af1d8f46ff8fc38307"
  end

  def install
    bin.install "got"
  end
end
