require_relative "../lib/php_extension_formula"

class PhpAT81Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  deprecate! date: "2024-11-25", because: :unsupported

  depends_on "enchant"
end
