require "language/go"

class GotSrc < Formula
  desc "Simple tmux tool with go -- installed with building from source code."
  homepage "https://github.com/skanehira/got/"
 
  keg_only "This formula conflictes with `z80oolong/tmux/got-bin`. To use the package, run `brew link --force `z80oolong/tmux/got-src`."

  depends_on "z80oolong/go/go@1.11" => :build
  depends_on "z80oolong/tmux/tmux" => :optional

  stable do
    url "https://github.com/skanehira/got/archive/v1.0.3.tar.gz"
    version "1.0.3"
    sha256 "4c602520b63e03fd7639b87b94d2661405cd3fd60fffd852c286a83d03d6ef71"

    go_resource "github.com/manifoldco/promptui" do
      url "https://github.com/manifoldco/promptui.git",
      :revision => "ad16ba47f57219da6f554d1136cd07a8543c1564"
    end

    go_resource "github.com/chzyer/readline" do
      url "https://github.com/chzyer/readline.git",
      :revision => "2972be24d48e78746da79ba8e24e8b488c9880de"
    end

    go_resource "github.com/juju/ansiterm" do
      url "https://github.com/juju/ansiterm.git",
      :revision => "720a0952cc2ac777afc295d9861263e2a4cf96a1"
    end

    go_resource "github.com/lunixbochs/vtclean" do
      url "https://github.com/lunixbochs/vtclean.git",
      :revision => "2d01aacdc34a083dca635ba869909f5fc0cd4f41"
    end

    go_resource "github.com/mattn/go-colorable" do
      url "https://github.com/mattn/go-colorable.git",
      :revision => "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
    end

    go_resource "github.com/mattn/go-isatty" do
      url "https://github.com/mattn/go-isatty.git",
      :revision => "3fb116b820352b7f0c281308a4d6250c22d94e27"
    end
  end

  head do
    url "https://github.com/skanehira/got.git"
  end

  def install
    ENV["GOPATH"] = buildpath/"build"

    (buildpath/"build/src/github.com/skanehira").mkpath
    system "ln", "-sf", "#{buildpath}", "#{buildpath}/build/src/github.com/skanehira/got"

    if build.head? then
      system "#{Formula["go"].opt_bin}/go", "get", "-v", "github.com/skanehira/got"
      bin.install buildpath/"build/bin/got"
    else
      Language::Go.stage_deps resources, buildpath/"build/src"
      system "#{Formula["go"].opt_bin}/go", "build", "-v", "-o", bin/"got", "github.com/skanehira/got"
    end

    (share/"doc/#{name}-#{version}").install "README.md"
  end
end
