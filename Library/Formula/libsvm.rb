require 'formula'

class Libsvm < Formula
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.11.tar.gz'
  md5 '44d2a3a611280ecd0d66aafe0d52233e'
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'

  def options
    [ "--python", "Install Python bindings."]
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
        system "make"
        # Python bindings are just two plain .py files:
        cp( ["svm.py", "svmutil.py"],
            "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages/",
            :verbose => true)
      end
      Dir.chdir "tools" do
        mkdir_p "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages/svmtools"
        cp( ["checkdata.py", "easy.py", "grid.py", "subset.py"],
            "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages/svmtools",
            :verbose => true )
      end
    end

    bin.install ['svm-scale', 'svm-train', 'svm-predict']
    lib.install ['libsvm.so.2', 'libsvm.dylib']
    include.install ['svm.h']
  end

  if ARGV.include? "--python"
    def caveats; <<-EOS.undent
      For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      Libsvm tools have bin installed to:
        "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages/svmtools"
      EOS
    end
  end

  def test
    system "make test"
  end
end


def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end
