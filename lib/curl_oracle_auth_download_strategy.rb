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
    username, password = self.class.credentials
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
