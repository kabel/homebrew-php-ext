require_relative "../lib/php_extension_formula"

class PhpAT83Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  deprecate! date: "2027-12-31", because: :unsupported

  depends_on "enchant"
end
