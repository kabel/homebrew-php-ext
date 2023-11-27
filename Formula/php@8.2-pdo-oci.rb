require_relative "../lib/oracle_php_extension_formula"

class PhpAT82PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  deprecate! date: "2025-12-08", because: :unsupported

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
