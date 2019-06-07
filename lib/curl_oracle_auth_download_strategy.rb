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

  def _fetch(url:, **)
    escape_data = ->(d) { ["-d", URI.encode_www_form([d])] }

    meta[:cookies] = self.class.cookies
    meta[:user_agent] = :browser
    meta[:referer] = "https://login.oracle.com/mysso/signon.jsp"

    username, password = self.class.credentials

    req_output, = curl_output(
      "--silent", "--location",
      "-c", self.class.cookie_jar,
      url
    )

    m = /name="OAM_REQ" value="([^"]+)"/.match(req_output)
    raise CurlDownloadStrategyError, "Invalid Oracle response." if m.nil?
    oam_req = m.captures.first

    # m = /name="site2pstoretoken" value="([^"]+)"/.match(req_output)
    # raise CurlDownloadStrategyError, "Invalid Oracle response." if m.nil?
    # site2pstoretoken = m.captures.first

    m = /name="request_id" value="([^"]+)"/.match(req_output)
    raise CurlDownloadStrategyError, "Invalid Oracle response." if m.nil?
    request_id = m.captures.first

    data = {
      "locale"           => "",
      "OAM_REQ"          => oam_req,
      "password"         => password,
      "request_id"       => request_id,
      # "site2pstoretoken" => site2pstoretoken,
      "ssousername"      => username,
      "v"                => "v1.4",
    }

    temporary_path.dirname.mkpath
    curl(
      "--location", "--remote-time", "--continue-at", 0,
      "--output", temporary_path,
      "-b", self.class.cookie_jar,
      "-c", self.class.cookie_jar,
      *data.flat_map(&escape_data),
      "https://login.oracle.com/oam/server/sso/auth_cred_submit"
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
      raise CurlDownloadStrategyError, "Bad Oracle Account credentials"
    end
  end

  def resolve_url_basename_time(url)
    [url, parse_basename(url), nil]
  end
end
