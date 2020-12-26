class AppimagePythonAT38 < Formula
  desc "AppImage package of Terminal multiplexer"
  homepage "https://tmux.github.io/"

  python_version = "3.8.6"
  appimage_version = "python3.8"
  url "https://github.com/niess/python-appimage/releases/download/#{appimage_version}/python#{python_version}-cp38-cp38-manylinux2014_x86_64.AppImage"
  sha256 "b7f90b5e0ad924b91cb7917827822b07d07c0b6b048bf57d877020ee581f070d"
  version python_version

  keg_only :versioned_formula

  option "with-extract", "Extract tmux AppImage."

  def appimage_python_name
    return "python#{version}-cp38-cp38-manylinux2014_x86_64.AppImage"
  end

  def appimage_python_path
    return libexec/appimage_python_name
  end

  def install
    (buildpath/appimage_python_name).chmod(0755)

    bin.mkdir; libexec.mkdir
    libexec.install "#{buildpath}/#{appimage_python_name}"

    if build.with?("extract") then
      libexec.cd do
        system "#{appimage_python_path}", "--appimage-extract"
      end
      inreplace (libexec/"squashfs-root/AppRun").to_s, /^APPDIR=.*$/, %{APPDIR="#{libexec}/squashfs-root"}

      (bin/"python").make_symlink (libexec/"squashfs-root/AppRun")
    else
      (bin/"python").make_symlink appimage_python_path
    end
  end
end
