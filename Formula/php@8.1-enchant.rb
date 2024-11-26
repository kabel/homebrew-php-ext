require_relative "../lib/php_extension_formula"

class PhpAT81Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  deprecate! date: "2025-12-31", because: :unsupported

  depends_on "enchant"
end
