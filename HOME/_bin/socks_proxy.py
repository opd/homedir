'''SOCKS proxy support

This extension enables SOCKS5 proxy support for Mercurial. You'll
also need the SocksiPy socks.py module for this to work, as this
implements the actual SOCKS protocol. Currently, only SOCKS5 is
supported, without a username or password.
'''
from mercurial import util
from mercurial.i18n import _
import socket


def uisetup(ui):
    proxyurl = ui.config("socks_proxy", "host")
    if proxyurl:
        idx = proxyurl.find(":")
        if idx < 0:
            raise util.Abort(_("host in socks_proxy should be "
                               "hostname:port"))
        host = proxyurl[:idx]
        portstr = proxyurl[idx+1:]
        try:
            port = int(portstr)
        except ValueError:
            raise util.Abort(_("Cannot interpret '%s' in the socks_proxy "
                               "host line as an integer port number")
                             % portstr)
        if port <= 0 or port > 65535:
            raise util.Abort(_("Port number in socks_proxy host line "
                               "must lie between 1 and 65535, but is %d")
                             % port)
        # ui.write("Setting SOCKS5 proxy to %s:%d\n" % (host, port))
        try:
            import socks
            socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, host, port)
            socket.socket = socks.socksocket
        except ImportError:
            raise util.Abort(_("The SocksiPy socks module is needed for "
                               "SOCKS support"))
