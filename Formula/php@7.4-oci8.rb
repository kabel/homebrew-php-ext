require_relative "../lib/oracle_php_extension_formula"

class PhpAT74Oci8 < OraclePhpExtensionFormula
  extension_dsl "OCI8 Extension"

  disable! date: "2022-11-28", because: :versioned_formula

  instantclient_options arg: "--with-oci8"
end
