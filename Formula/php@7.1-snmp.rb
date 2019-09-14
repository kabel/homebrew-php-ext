require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT71Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  depends_on "net-snmp"
  depends_on "openssl@1.1"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
