require_relative "../lib/php_extension_formula"

class PhpAT80Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  depends_on "enchant"
end
