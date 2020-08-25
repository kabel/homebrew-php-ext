require_relative "../lib/oracle_php_extension_formula"

class PhpAT72Oci8 < OraclePhpExtensionFormula
  extension_dsl "OCI8 Extension"
  instantclient_options arg: "--with-oci8"
end
