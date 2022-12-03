require_relative "../lib/php_extension_formula"

class PhpAT80Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  deprecate! date: "2022-11-26", because: :versioned_formula

  depends_on "net-snmp"
  depends_on "openssl@1.1"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
