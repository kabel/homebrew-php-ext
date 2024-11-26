require_relative "../lib/oracle_php_extension_formula"

class PhpAT82PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  deprecate! date: "2026-12-31", because: :unsupported

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
