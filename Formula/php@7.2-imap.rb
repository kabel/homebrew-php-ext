require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT72Imap < PhpExtensionFormula
  extension_dsl "IMAP Extension"

  conflicts_with "php@7.2-recode", :because => "because both share the same internal symbols"

  depends_on "imap-uw"
  depends_on "openssl@1.1"

  configure_arg %W[
    --with-imap=#{Formula["imap-uw"].opt_prefix}
    --with-imap-ssl=#{Formula["openssl@1.1"].opt_prefix}
    --with-kerberos
  ]
end
