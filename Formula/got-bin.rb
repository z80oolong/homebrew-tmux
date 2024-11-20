class GotBin < Formula
  desc "Simple tmux tool with go -- installed with binary code"
  homepage "https://github.com/skanehira/got/"
  revision 2

  if OS.linux?
    url "https://github.com/skanehira/got/releases/download/v1.0.3/Linux.zip"
    sha256 "99ce5d47a2156ad68a9eb71c2f8a7794d81a9e613e78e2bfbd1ae97765abd89a"
  elsif OS.mac?
    url "https://github.com/skanehira/got/releases/download/v1.0.3/MacOS.zip"
    sha256 "39112cb56582018e4262e84bb1432935f20392373d6da81e6cde1861fc56ef76"
  end

  depends_on "z80oolong/tmux/tmux" => :optional

  def install
    # `got` binary file is x86-64 Linux or Mac OS X architecture only.
    if Hardware::CPU.is_32_bit? || (!OS.linux? && !OS.mac?)
      msg  = "This formula can't use for this architecture.\n"
      msg << "use `brew install z80oolong/tmux/got-src` and `brew link --force got-src`."
      raise msg
    end

    bin.install "got"
  end
end
