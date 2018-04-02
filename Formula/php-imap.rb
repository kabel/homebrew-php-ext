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

class PhpImap < PhpExtensionFormula
  desc "IMAP Extension for PHP 7.2"
  extension_dsl

  conflicts_with "php-recode", :because => "because both share the same internal symbols"

  depends_on "imap-uw"
  depends_on "openssl"

  configure_arg %W[
    --with-imap=#{Formula["imap-uw"].opt_prefix}
    --with-imap-ssl=#{Formula["openssl"].opt_prefix}
    --with-kerberos
  ]
end
