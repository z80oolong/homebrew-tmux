class TpmAT310 < Formula
  desc "Tmux Plugin Manager"
  homepage "https://github.com/tmux-plugins/tpm"
  url "https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "2411fc416c4475d297f61078d0a03afb3a1f5322fff26a13fdb4f20d7e975570"
  revision 2

  keg_only :versioned_formula

  depends_on "z80oolong/tmux/tmux"

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
        run-shell '#{opt_libexec}/#{name}/tpm'
        ...
    EOS
  end

  test do
    ENV["LC_ALL"] = "ja_JP.UTF-8"
    assert_empty shell_output(libexec/"#{name}/tpm")
  end
end
