require_relative "../lib/php_extension_formula"
require_relative "../lib/curl_oracle_auth_download_strategy"

class OraclePhpExtensionFormula < PhpExtensionFormula
  def install
    (prefix/"instantclient").install resource("instantclient-basic")
    (prefix/"instantclient").install resource("instantclient-sdk")

    instantclient_version = resource("instantclient-basic")
                            .version
                            .to_s
                            .split("-")[0]

    arg = "#{self.class.instantclient_arg}=instantclient,#{prefix}/instantclient"
    arg << ",#{instantclient_version}" if self.class.instantclient_with_version

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
        url "https://download.oracle.com/otn_software/mac/instantclient/193000/instantclient-basic-macos.x64-19.3.0.0.0dbru.zip"
        sha256 "f4335c1d53e8188a3a8cdfb97494ff87c4d0f481309284cf086dc64080a60abd"
      end

      resource "instantclient-sdk" do
        url "https://download.oracle.com/otn_software/mac/instantclient/193000/instantclient-sdk-macos.x64-19.3.0.0.0dbru.zip"
        sha256 "b46b4b87af593f7cfe447cfb903d1ae5073cec34049143ad8cdc9f3e78b23b27"
      end
    end
  end
end
