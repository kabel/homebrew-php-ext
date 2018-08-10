class PhpExtensionFormula < Formula
  def initialize(*)
    super
    active_spec.owner = php_parent.stable.owner
  end

  def install
    cd "#{extension}-#{version}"
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

class PhpUuid < PhpExtensionFormula
  desc "UUID Extension for PHP 7.2"
  extension_dsl

  depends_on "ossp-uuid"

  stable do
    url "https://pecl.php.net/get/uuid-1.0.4.tgz"
    sha256 "63079b6a62a9d43691ecbcd4eb52e5e5fe17b5a3d0f8e46e3c17ff265c06a11f"

    patch do
      # let's fix the path to uuid.h (uuid/uuid.h on linux, ossp/uuid.h on OSX)
      # uuid_mac & uuid_time might not be available on OSX, let's add test to avoid compiling issue on these functions
      url "https://gist.githubusercontent.com/romainneutron/fe068c297413aee565d5/raw/28d6ba0b6e902e82e71bb9a1ed768c836a8161e4/php-uuid-1.0.4"
      sha256 "5f0664d5c4f55d4f6c037dab9f198e697afa3f9266854ed3945d7697fdb692b2"
    end
  end
  bottle do
    cellar :any_skip_relocation
    sha256 "ab1f3636c3a0c7fd026a39a1d5f5ebe088fe6e28076ce88c8a13b067cb981b12" => :el_capitan
    sha256 "95d3212fb55d4dcf5c67740757fa7ffa22542ad3cd8bcf5b3d07a05f663af952" => :yosemite
    sha256 "c22f027d7ece0ce7d1b1cc28776ba903abd9800ca43313350c122b4a16f333bd" => :mavericks
  end

  head do
    url "https://git.php.net/repository/pecl/networking/uuid.git"

    patch do
      # let's fix the path to uuid.h (uuid/uuid.h on linux, ossp/uuid.h on OSX)
      # uuid_mac & uuid_time might not be available on OSX, let's add test to avoid compiling issue on these functions
      url "https://gist.githubusercontent.com/romainneutron/059b5795d205640ebf5a/raw/3ccec57f9a960ee04e4c2f9d80b16ab070d0fe65/php-uuid-master"
      sha256 "4025b2e99032b447fcf244dacac7fdeb601b3aa40204a3cdd9e475c5c2fa15cd"
    end
  end

  def install
    configure_args.concat(
      %W[
        --with-uuid=#{Formula["ossp-uuid"].opt_include}
      ],
    )
    super
  end
end
