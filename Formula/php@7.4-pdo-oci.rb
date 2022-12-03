require_relative "../lib/oracle_php_extension_formula"

class PhpAT74PdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"

  disable! date: "2022-11-28", because: :versioned_formula

  instantclient_options arg: "--with-pdo-oci", with_version: true
end
