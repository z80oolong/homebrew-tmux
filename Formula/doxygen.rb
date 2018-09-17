class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://github.com/doxygen/doxygen/archive/Release_1_8_14.tar.gz"
  version "1.8.14"
  sha256 "18bc3790b4d5f4d57cb8ee0a77dd63a52518f3f70d7fdff868a7ce7961a6edc3"
  head "https://github.com/doxygen/doxygen.git"

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  deprecated_option "with-dot" => "with-graphviz"
  deprecated_option "with-doxywizard" => "with-qt"
  deprecated_option "with-libclang" => "with-llvm"
  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" => :optional
  depends_on "llvm" => :optional
  depends_on "bison" unless OS.mac?
  depends_on "flex" unless OS.mac?

  def install
    args = std_cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}"
    args << "-Dbuild_wizard=ON" if build.with? "qt"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
