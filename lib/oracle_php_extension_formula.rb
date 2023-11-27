# frozen_string_literal: true

require_relative "../lib/php_extension_formula"

class OraclePhpExtensionFormula < PhpExtensionFormula
  def install
    (prefix/"instantclient").install resource("instantclient-basic")
    (prefix/"instantclient").install resource("instantclient-sdk")

    instantclient_version = resource("instantclient-basic")
                            .version
                            .to_s
                            .split("-")[0]

    arg = "#{self.class.instantclient_arg}=instantclient,#{prefix}/instantclient"
    arg += ",#{instantclient_version}" if self.class.instantclient_with_version

    configure_args << arg
    super
  end

  def caveats
    <<~EOS
      Installing this Formula means you have AGREED to the Oracle Technology Network License Agreement at

        http://www.oracle.com/technetwork/licenses/instant-client-lic-152016.html

      You must also have an Oracle Account. You can register for a free account at

        https://profile.oracle.com/myprofile/account/create-account.jspx
    EOS
  end

  class << self
    attr_reader :instantclient_arg, :instantclient_with_version

    def instantclient_options(options)
      @instantclient_arg = options[:arg]
      @instantclient_with_version = options[:with_version]
    end

    def extension_dsl(*)
      super
      resource "instantclient-basic" do
        url "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-basic-macos.x64-19.8.0.0.0dbru.zip"
        sha256 "57ed4198f3a10d83cd5ddc2472c058d4c3b0b786246baebf6bbfc7391cc12087"
      end

      resource "instantclient-sdk" do
        url "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-sdk-macos.x64-19.8.0.0.0dbru.zip"
        sha256 "0fa8ae4c4418aa66ce875cf92e728dd7a81aeaf2e68e7926e102b5e52fc8ba4c"
      end
    end
  end
end
