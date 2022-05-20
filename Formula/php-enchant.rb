require_relative "../lib/php_extension_formula"

class PhpEnchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  depends_on "enchant"
end
