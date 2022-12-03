require_relative "../lib/php_extension_formula"

class PhpAT80Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  deprecate! date: "2022-11-26", because: :versioned_formula

  depends_on "enchant"
end
