require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT71Memcache < PhpExtensionFormula
  extension_dsl "Memcache Extension"

  url "https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.tar.gz"
  sha256 "8a14cb069cd8ec06db24db630c7c8405a7417b1a3d821bac34f2177ed5208439"

  def install
    system php_parent.bin/"phpize"
    system "./configure", *configure_args
    system "make"
    (lib/module_path).install "modules/#{extension}.so"
  end
end
