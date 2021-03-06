require 'formula'

class Nginx < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.6.2.tar.gz'
  sha1 '1a5458bc15acf90eea16353a1dd17285cf97ec35'
  version '1.6.2-boxen2'

  depends_on 'pcre'
  depends_on "openssl" => :recommended

  skip_clean 'logs'

  def options
    [
      ['--with-passenger',   "Compile with support for Phusion Passenger module"],
      ['--with-webdav',      "Compile with support for WebDAV module"],
      ['--with-gzip-static', "Compile with support for Gzip Static module"]
    ]
  end

  def passenger_config_args
      passenger_root = `passenger-config --root`.chomp

      if File.directory?(passenger_root)
        return "--add-module=#{passenger_root}/ext/nginx"
      end

      puts "Unable to install nginx with passenger support. The passenger"
      puts "gem must be installed and passenger-config must be in your path"
      puts "in order to continue."
      exit
  end

  def install
    pcre = Formula["pcre"]
    openssl = Formula["openssl"]
    cc_opt = "-I#{pcre.include} -I#{openssl.include} -I#{HOMEBREW_PREFIX}/include"
    ld_opt = "-L#{pcre.lib} -L#{openssl.lib} -L#{HOMEBREW_PREFIX}/lib"

    args = ["--prefix=#{prefix}",
            "--with-http_ssl_module",
            "--with-pcre",
            "--with-ipv6",
            "--with-cc-opt=#{cc_opt}",
            "--with-ld-opt=#{ld_opt}",
            "--conf-path=/opt/boxen/config/nginx/nginx.conf",
            "--pid-path=/opt/boxen/data/nginx/nginx.pid",
            "--lock-path=/opt/boxen/data/nginx/nginx.lock"]

    args << passenger_config_args if ARGV.include? '--with-passenger'
    args << "--with-http_dav_module" if ARGV.include? '--with-webdav'
    args << "--with-http_gzip_static_module" if ARGV.include? '--with-gzip-static'

    system "./configure", *args
    system "make"
    system "make install"
    man8.install "objs/nginx.8"

    # remove unnecessary config files
    system "rm -rf #{etc}/nginx"
  end
end
