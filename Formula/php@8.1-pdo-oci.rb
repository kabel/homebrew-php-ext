require_relative "../lib/oracle_php_extension_formula"

class PhpAT81PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  deprecate! date: "2025-12-31", because: :unsupported

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
