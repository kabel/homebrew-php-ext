require_relative "../lib/php_extension_formula"

class PhpAT73Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  disable! date: "2021-12-06", because: :versioned_formula

  depends_on "net-snmp"
  depends_on "openssl@1.1"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
