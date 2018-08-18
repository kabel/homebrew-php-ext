require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT56Tidy < PhpExtensionFormula
  extension_dsl "Tidy Extension"

  depends_on "tidy-html5"

  configure_arg "--with-tidy=#{Formula["tidy-html5"].opt_prefix}"

  def install
    # API compatibility with tidy-html5 v5.0.0 - https://github.com/htacg/tidy-html5/issues/224
    inreplace "ext/#{extension}/tidy.c", "buffio.h", "tidybuffio.h"
    super
  end
end
