class PhpExtensionFormula < Formula
  def initialize(*)
    super
    active_spec.owner = php_parent.stable.owner
  end

  def install
    cd "ext/#{extension}"
    system php_parent.bin/"phpize"
    system "./configure", *configure_args
    system "make"
    (lib/module_path).install "modules/#{extension}.so"
  end

  def post_install
    ext_config_path = etc/"php"/php_parent.php_version/"conf.d"/"ext-#{extension}.ini"
    if ext_config_path.exist?
      inreplace ext_config_path,
        /#{extension_type}=.*$/, "#{extension_type}=#{opt_lib/module_path}/#{extension}.so"
    else
      ext_config_path.write <<~EOS
        [#{extension}]
        #{extension_type}=#{opt_lib/module_path}/#{extension}.so
      EOS
    end
  end

  test do
    assert_match extension.downcase, shell_output("#{php_parent.opt_bin}/php -m").downcase,
      "failed to find extension in php -m output"
  end

  private

  def php_parent
    self.class.php_parent
  end

  def extension
    self.class.extension
  end

  def extension_type
    # extension or zend_extension
    "extension"
  end

  def module_path
    extension_dir = Utils.popen_read("#{php_parent.opt_bin/"php-config"} --extension-dir").chomp
    php_basename = File.basename(extension_dir)
    "php/#{php_basename}"
  end

  def configure_args
    self.class.configure_args
  end

  class << self
    NAME_PATTERN = /^Php(?:AT([57])(\d+))?(.+)/
    attr_reader :configure_args, :php_parent, :extension

    def configure_arg(args)
      @configure_args ||= []
      @configure_args.concat(Array(args))
    end

    def extension_dsl
      class_name = name.split("::").last
      m = NAME_PATTERN.match(class_name)
      if m.nil?
        raise "Bad PHP Extension name for #{class_name}"
      elsif m[1].nil?
        parent_name = "php"
      else
        parent_name = "php@" + m.captures[0..1].join(".")
      end

      @php_parent = Formula[parent_name]
      @extension = m[3].gsub(/([a-z])([A-Z])/) do
        Regexp.last_match(1) + "_" + Regexp.last_match(2)
      end.downcase
      @configure_args = %W[
        --with-php-config=#{php_parent.opt_bin/"php-config"}
      ]

      homepage php_parent.homepage + extension
      url php_parent.stable.url
      send php_parent.stable.checksum.hash_type, php_parent.stable.checksum.hexdigest

      depends_on "autoconf" => :build
      depends_on parent_name
    end
  end
end

class CurlOracleAuthDownloadStrategy < CurlDownloadStrategy
  class << self
    attr_reader :username, :password
    attr_accessor :cookies, :cookie_jar

    def clean
      @username = @password = nil
      return if cookie_jar.nil?
      return unless cookie_jar.exist?
      cookie_jar.delete
    end

    def credentials
      @username ||= ENV["HOMEBREW_ORACLE_USERNAME"]
      @password ||= ENV["HOMEBREW_ORACLE_PASSWORD"]

      return [@username, @password] unless @username.nil? || @password.nil?

      require "io/console"
      ohai "You must have an Oracle Account to continue."
      ohai "Enter your Oracle Account username: "
      @username = $stdin.gets.chomp
      ohai "Enter your Oracle Account password: "
      @password = $stdin.noecho(&:gets).chomp

      if @username.empty? || @password.empty?
        clean
        odie "Invalid Oracle Account"
      end

      [@username, @password]
    end

    def with_session(cookie, jar)
      @cookies = cookie
      @cookie_jar = jar
      yield
      clean
    end
  end

  private

  def _fetch
    cookies = self.class.cookies
                  .sort_by(&:to_s)
                  .map { |key, value| "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}" }
                  .join(";")
    username, password = self.class.get_credentials
    referer = "http://www.oracle.com/"

    req_output, = curl_output(
      "--silent",
      "--cookie", cookies, "--cookie-jar", self.class.cookie_jar,
      "--referer", referer,
      "--location", @url,
      :user_agent => :browser
    )

    m = /name="OAM_REQ" value="([^"]+)"/.match(req_output)
    odie "Invalid Oracle response." if m.nil?
    oam_req = m.captures.first

    curl_download(
      "--cookie", cookies, "--cookie-jar", self.class.cookie_jar,
      "--referer", referer,
      "--data-urlencode", "ssousername=#{username}",
      "--data-urlencode", "password=#{password}",
      "--data-urlencode", "OAM_REQ=#{oam_req}",
      "https://login.oracle.com/oam/server/sso/auth_cred_submit",
      :to => temporary_path, :user_agent => :browser
    )

    auth_fail = false

    temporary_path.each_line do |line|
      if line.include? "https://login.oracle.com/mysso/signon.jsp"
        auth_fail = true
        break
      end
    end

    if auth_fail
      temporary_path.delete
      odie "Bad Oracle Account credentials"
    end
  end
end

class PhpAT71Oci8 < PhpExtensionFormula
  desc "OCI8 Extension for PHP 7.1"
  extension_dsl

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

  def install
    CurlOracleAuthDownloadStrategy.with_session(
      { "oraclelicense" => "accept-ic_solarisx8664-cookie" },
      buildpath/".cookie_jar",
    ) do
      (prefix/"instantclient").install resource("instantclient-basic")
      (prefix/"instantclient").install resource("instantclient-sdk")
    end

    configure_args.concat(
      %W[
        --with-oci8=instantclient,#{prefix}/instantclient
      ],
    )
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
end
