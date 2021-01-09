# frozen_string_literal: true

class PhpExtensionFormula < Formula
  desc "PHP Extension"
  homepage "https://www.php.net/"

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
    (include/"php/ext"/extension).install Dir["php_*.h"]
  end

  def post_install
    ext_config_path = etc/"php"/php_parent.version.major_minor/"conf.d"/"ext-#{extension}.ini"
    if ext_config_path.exist?
      inreplace ext_config_path,
                /#{extension_type}=.*$/,
                "#{extension_type}=#{opt_lib/module_path}/#{extension}.so"
    else
      ext_config_path.write <<~EOS
        [#{extension}]
        #{extension_type}=#{opt_lib/module_path}/#{extension}.so
      EOS
    end
  end

  test do
    assert_match extension.downcase,
                 shell_output("#{php_parent.opt_bin}/php -m").downcase,
                 "failed to find extension in php -m output"
  end

  private

  delegate [:php_parent, :extension, :configure_args] => :"self.class"

  def extension_type
    # extension or zend_extension
    "extension"
  end

  def module_path
    extension_dir = Utils.safe_popen_read(php_parent.opt_bin/"php-config", "--extension-dir").chomp
    php_basename = File.basename(extension_dir)
    "php/#{php_basename}"
  end

  class << self
    NAME_PATTERN = /^Php(?:AT([578])(\d+))?(.+)/.freeze
    attr_reader :configure_args, :php_parent, :extension

    def configure_arg(args)
      @configure_args ||= []
      @configure_args.concat(Array(args))
    end

    def extension_dsl(description = nil)
      class_name = name.split("::").last
      m = NAME_PATTERN.match(class_name)
      raise "Bad PHP Extension name for #{class_name}" if m.nil?

      if m[1].nil?
        parent_name = "php"
      else
        parent_name = "php@#{m.captures[0..1].join(".")}"
        keg_only :versioned_formula
      end

      @php_parent = Formula[parent_name]
      @extension = m[3].gsub(/([a-z])([A-Z])/) do
        "#{Regexp.last_match(1)}_#{Regexp.last_match(2)}"
      end.downcase
      @configure_args = %W[
        --with-php-config=#{php_parent.opt_bin/"php-config"}
      ]

      desc "#{description} for PHP #{php_parent.version.major_minor}" unless description.nil?

      homepage php_parent.homepage + extension
      url php_parent.stable.url
      sha256 php_parent.stable.checksum.hexdigest

      depends_on "autoconf" => :build
      depends_on "pkg-config" => :build
      depends_on parent_name
    end
  end
end
