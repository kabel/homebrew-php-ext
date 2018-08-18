require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpSnmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  depends_on "net-snmp"
  depends_on "openssl"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"

  def caveats
    "WARNING: The extension is known to crash httpd on High Sierra when using the php module."
  end
end
