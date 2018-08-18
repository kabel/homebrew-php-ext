require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT71Tidy < PhpExtensionFormula
  extension_dsl "Tidy Extension"

  depends_on "tidy-html5"

  configure_arg "--with-tidy=#{Formula["tidy-html5"].opt_prefix}"
end
