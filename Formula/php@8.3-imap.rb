require_relative "../lib/php_extension_formula"

class PhpAT83Imap < PhpExtensionFormula
  extension_dsl "IMAP Extension"

  deprecate! date: "2027-12-31", because: :unsupported

  depends_on "imap-uw"
  depends_on "openssl@3"
  depends_on "krb5"

  configure_arg %W[
    --with-imap=#{Formula["imap-uw"].opt_prefix}
    --with-imap-ssl=#{Formula["openssl@3"].opt_prefix}
    --with-kerberos
  ]

  def install
    ENV["PHP_OPENSSL"] = "yes"
    super
  end
end
