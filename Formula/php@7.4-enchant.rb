require_relative "../lib/php_extension_formula"

class PhpAT74Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  disable! date: "2022-11-28", because: :versioned_formula

  depends_on "enchant"
end
