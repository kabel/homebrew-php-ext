require_relative "../lib/php_extension_formula"

class PhpAT81Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  deprecate! date: "2024-11-25", because: :unsupported

  depends_on "net-snmp"
  depends_on "openssl@3"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
