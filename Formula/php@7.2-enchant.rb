require File.expand_path("../lib/php_extension_formula", __dir__)

class PhpAT72Enchant < PhpExtensionFormula
  extension_dsl "Enchant Extension"

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "glib"

  resource "enchant" do
    url "https://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz"
    sha256 "2fac9e7be7e9424b2c5570d8affe568db39f7572c10ed48d4e13cddf03f7097f"
  end

  def install
    configure_args << "--with-enchant=#{prefix}/vendor"

    resource("enchant").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}/vendor",
                            "--disable-ispell",
                            "--disable-myspell"

      system "make", "install"
    end
    super
  end
end
