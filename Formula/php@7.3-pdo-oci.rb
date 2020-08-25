require_relative "../lib/oracle_php_extension_formula"

class PhpAT73PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"
  instantclient_options arg: "--with-pdo-oci", with_version: true
end
