require_relative "../lib/oracle_php_extension_formula"

class PhpAT80PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  deprecate! date: "2022-11-26", because: :versioned_formula

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
