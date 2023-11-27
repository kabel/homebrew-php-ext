require_relative "../lib/oracle_php_extension_formula"

class PhpAT81PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  deprecate! date: "2024-11-25", because: :unsupported

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
