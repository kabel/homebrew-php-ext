require_relative "../lib/oracle_php_extension_formula"

class PhpAT82Oci8 < OraclePhpExtensionFormula
  extension_dsl "OCI8 Extension"

  deprecate! date: "2026-12-31", because: :unsupported

  instantclient_options arg: "--with-oci8"
end
