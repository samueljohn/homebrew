require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.11.tar.gz'
  md5 '44d2a3a611280ecd0d66aafe0d52233e'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'

  def options
    [
      ["--python", "Install Python bindings."],
      ["--qt", "Install qt4-based gui called svm-toy."]
    ]
  end

  def install
    # http://stackoverflow.com/questions/4580789/cmake-mac-os-x-ld-unknown-option-soname
    inreplace 'Makefile', '-soname', '-install_name'

    system "make"
    system "make lib"
    # Make the built lib Mac conform, so later python can find_library("libsvm")
    ln_s 'libsvm.so.2', 'libsvm.dylib'

    if ARGV.include? "--python"
      Dir.chdir "python" do
        ohai "Python bindings and tools..."
        system "make"
        # Python bindings are just two plain .py files:
        mkdir_p "#{lib}/#{pythonxy}/site-packages/"
        cp( ["svm.py", "svmutil.py"],
            "#{lib}/#{pythonxy}/site-packages/",
            :verbose => true)
      end
      Dir.chdir "tools" do
        mkdir_p "#{lib}/#{pythonxy}/site-packages/svmtools"
        cp( ["checkdata.py", "easy.py", "grid.py", "subset.py"],
            "#{lib}/#{pythonxy}/site-packages/svmtools",
            :verbose => true )
      end
    end

    if ARGV.include? "--qt"
      Dir.chdir "svm-toy/qt" do
        ENV.append("CFLAGS", "-L#{HOMEBREW_PREFIX}/lib/QtGui.framework/")
        # todo lQtGui is not found because there is no libQtGui ... hmmm
        system "make", "INCLUDE=#{HOMEBREW_PREFIX}/include", "MOC=moc"
        bin.install "svm-toy"
      end
    end

    bin.install ['svm-scale', 'svm-train', 'svm-predict']
    lib.install ['libsvm.so.2', 'libsvm.dylib']
    include.install ['svm.h']
  end

  def caveats
    s = ""
    python_caveats = <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{pythonxy}/site-packages:$PYTHONPATH
    Libsvm tools have bin installed to:
      "#{HOMEBREW_PREFIX}/lib/#{pythonxy}/site-packages/svmtools"
    EOS
    s += python_caveats if ARGV.include? "--python"
  end

  def test
    # todo
  end
end


def pythonxy
  # Something like "python2.7"
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end
