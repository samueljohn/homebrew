require 'formula'

class Pypcap < Formula
  homepage 'http://code.google.com/p/pypcap/'
  url 'http://pypcap.googlecode.com/files/pypcap-1.1.tar.gz'
  sha1 '966f62deca16d5086e2ef6694b0c795f273da15c'

  def install
    system 'python', 'setup.py', 'config'
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
