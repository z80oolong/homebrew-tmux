class GotSrc < Formula
  desc "Simple tmux tool with go -- installed with building from source code"
  homepage "https://github.com/skanehira/got/"
  revision 3
  head "https://github.com/skanehira/got.git"

  stable do
    url "https://github.com/skanehira/got/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "4c602520b63e03fd7639b87b94d2661405cd3fd60fffd852c286a83d03d6ef71"

    resource "github.com/manifoldco/promptui" do
      url "https://github.com/manifoldco/promptui.git",
        revision: "c2e487d3597f59bcf76b24c9e80679740a72212b"
    end

    resource "github.com/chzyer/readline" do
      url "https://github.com/chzyer/readline.git",
        revision: "2972be24d48e78746da79ba8e24e8b488c9880de"
    end

    resource "github.com/juju/ansiterm" do
      url "https://github.com/juju/ansiterm.git",
        revision: "8b71cc96ebdcf1786021219160dacfda2b51cdbe"
    end

    resource "github.com/lunixbochs/vtclean" do
      url "https://github.com/lunixbochs/vtclean.git",
        revision: "f100a8e216a83682eb0f7516aa66ab3d62415d3b"
    end

    resource "github.com/mattn/go-colorable" do
      url "https://github.com/mattn/go-colorable.git",
        revision: "2b733b5d5ca7f3959b874da32dd775822a35a1a2"
    end

    resource "github.com/mattn/go-isatty" do
      url "https://github.com/mattn/go-isatty.git",
        revision: "a7c02353c47bc4ec6b30dc9628154ae4fe760c11"
    end
  end

  keg_only "this formula conflicts with 'z80oolong/tmux/got-bin'"

  depends_on "go@1.22" => :build
  depends_on "z80oolong/tmux/tmux" => :optional

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/skanehira").mkpath
    (buildpath/"src/github.com/skanehira").install_symlink buildpath => "got"

    if build.head?
      system Formula["go@1.22"].opt_bin/"go", "install", "-v", "github.com/skanehira/got@latest"
      bin.install buildpath/"bin/got"
    else
      resources.each { |resource| (buildpath/"src"/resource.name).install resource }
      system Formula["go@1.22"].opt_bin/"go", "build", "-v", "-o", bin/"got", "github.com/skanehira/got"
    end

    (share/"doc/#{name}-#{version}").install "README.md"
  end
end
