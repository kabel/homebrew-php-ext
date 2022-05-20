require_relative "../lib/php_extension_formula"

class PhpAT80Recode < PhpExtensionFormula
  extension_dsl "GNU Recode Extension"

  conflicts_with "php@8.0-imap", because: "because both share the same internal symbols"

  depends_on "recode"

  configure_arg "--with-recode=#{Formula["recode"].opt_prefix}"
end