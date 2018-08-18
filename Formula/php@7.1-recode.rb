require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT71Recode < PhpExtensionFormula
  extension_dsl "GNU Recode Extension"

  conflicts_with "php@7.1-imap", :because => "because both share the same internal symbols"

  depends_on "recode"

  configure_arg "--with-recode=#{Formula["recode"].opt_prefix}"
end
