require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT70Recode < PhpExtensionFormula
  extension_dsl "GNU Recode Extension"

  conflicts_with "php@7.0-imap", :because => "because both share the same internal symbols"

  depends_on "recode"

  configure_arg "--with-recode=#{Formula["recode"].opt_prefix}"
end
