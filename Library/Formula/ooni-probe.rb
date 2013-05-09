require 'formula'

class OoniProbe < Formula
  homepage 'https://github.com/TheTorProject/ooni-probe'
  url 'https://github.com/TheTorProject/ooni-probe/archive/v0.0.10.tar.gz'
  sha1 '2028840ef0ccf1eab79012b3c7287b805e573eba'

  depends_on 'argparse' => :python
  depends_on 'docutils' => :python
  depends_on 'ipaddr' => :python
  depends_on 'pygeoip' => :python
  depends_on 'repoze.sphinx.autointerface' => :python
  depends_on 'scapy' => :python
  depends_on 'txsocksx' => :python
  depends_on 'storm' => :python
  depends_on 'transaction' => :python
  depends_on 'txtorcon' => :python
  depends_on 'wsgiref' => :python
  depends_on 'zope.component' => :python
  depends_on 'zope.event' => :python
  depends_on 'zope.interface' => :python

  depends_on 'libdnet'
  depends_on 'scapy'
  depends_on 'pyrex' => :python
  depends_on 'pypcap'

  def install
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
