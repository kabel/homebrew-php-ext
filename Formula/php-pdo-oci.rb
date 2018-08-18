require File.expand_path("../lib/oracle_php_extension_formula", __dir__)

class PhpPdoOci < OraclePhpExtensionFormula
  extension_dsl "PDO Driver OCI"
  instantclient_options :arg => "--with-pdo-oci", :with_version => true
end
