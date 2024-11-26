require_relative "../lib/php_extension_formula"

class PhpAT82Snmp < PhpExtensionFormula
  extension_dsl "SNMP Extension"

  deprecate! date: "2026-12-31", because: :unsupported

  depends_on "net-snmp"
  depends_on "openssl@3"

  configure_arg "--with-snmp=#{Formula["net-snmp"].opt_prefix}"
end
