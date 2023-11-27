require_relative "../lib/php_extension_formula"

class PhpAT82Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  deprecate! date: "2025-12-08", because: :unsupported

  depends_on "enchant"
end
