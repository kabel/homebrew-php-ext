require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpTidy < PhpExtensionFormula
  extension_dsl "Tidy Extension"

  depends_on "tidy-html5"

  configure_arg "--with-tidy=#{Formula["tidy-html5"].opt_prefix}"
end
