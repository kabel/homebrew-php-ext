require_relative "../lib/oracle_php_extension_formula"

class PhpAT80Oci8 < OraclePhpExtensionFormula
  extension_dsl "OCI8 Extension"

  deprecate! date: "2022-11-26", because: :versioned_formula

  instantclient_options arg: "--with-oci8"
end
