require_relative "../lib/php_extension_formula"

class PhpAT72Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  depends_on "net-snmp"
  depends_on "openssl@1.1"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
