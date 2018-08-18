require File.expand_path("../lib/php_extension_formula", __dir__)
require File.expand_path("../lib/curl_oracle_auth_download_strategy", __dir__)

class OraclePhpExtensionFormula < PhpExtensionFormula
  def install
    CurlOracleAuthDownloadStrategy.with_session(
      { "oraclelicense" => "accept-ic_solarisx8664-cookie" },
      buildpath/".cookie_jar",
    ) do
      (prefix/"instantclient").install resource("instantclient-basic")
      (prefix/"instantclient").install resource("instantclient-sdk")
    end

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
        url "http://download.oracle.com/otn/mac/instantclient/122010/instantclient-basic-macos.x64-12.2.0.1.0-2.zip",
          :using => CurlOracleAuthDownloadStrategy
        sha256 "3ed3102e5a24f0da638694191edb34933309fb472eb1df21ad5c86eedac3ebb9"
      end

      resource "instantclient-sdk" do
        url "http://download.oracle.com/otn/mac/instantclient/122010/instantclient-sdk-macos.x64-12.2.0.1.0-2.zip",
          :using => CurlOracleAuthDownloadStrategy
        sha256 "e0befca9c4e71ebc9f444957ffa70f01aeeec5976ea27c40406471b04c34848b"
      end
    end
  end
end
