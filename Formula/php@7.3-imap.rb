require_relative "../lib/php_extension_formula"

class PhpAT73Imap < PhpExtensionFormula
  extension_dsl "IMAP Extension"

  disable! date: "2021-12-06", because: :versioned_formula

  depends_on "imap-uw"
  depends_on "openssl@1.1"
  depends_on "krb5"

  configure_arg %W[
    --with-imap=#{Formula["imap-uw"].opt_prefix}
    --with-imap-ssl=#{Formula["openssl@1.1"].opt_prefix}
    --with-kerberos
  ]
end
