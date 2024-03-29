require_relative "../lib/php_extension_formula"

class PhpAT80Imap < PhpExtensionFormula
  extension_dsl "IMAP Extension"

  deprecate! date: "2022-11-26", because: :versioned_formula

  depends_on "imap-uw"
  depends_on "openssl@3"
  depends_on "krb5"

  configure_arg %W[
    --with-imap=#{Formula["imap-uw"].opt_prefix}
    --with-imap-ssl=#{Formula["openssl@3"].opt_prefix}
    --with-kerberos
  ]
end
