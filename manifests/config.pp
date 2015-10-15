# Internal: Manage configuration files for nginx

class nginx::config(
  $ensure    = undef,
  $configdir = undef,
  $datadir   = undef,
  $logdir    = undef,
  $sitesdir  = undef,
  $user      = undef,
) {

  $dir_ensure = $ensure ? {
    present => directory,
    default => absent,
  }

  file { [
    $configdir,
    $datadir,
    $logdir,
    $sitesdir
  ]:
    ensure => $dir_ensure
  }

  file {
    "${configdir}/fastcgi_params":
      ensure => $ensure,
      source => 'puppet:///modules/nginx/config/nginx/fastcgi_params',
      require => File[$configdir];

    "${configdir}/mime.types":
      ensure => $ensure,
      source => 'puppet:///modules/nginx/config/nginx/mime.types',
      require => File[$configdir];

    "${configdir}/nginx.conf":
      ensure  => $ensure,
      content => template('nginx/config/nginx/nginx.conf.erb'),
      require => File[$configdir];

    "${configdir}/public":
      ensure  => $dir_ensure,
      recurse => true,
      source  => 'puppet:///modules/nginx/config/nginx/public',
      require => File[$configdir];

    "${configdir}/scgi_params":
      ensure => $ensure,
      source => 'puppet:///modules/nginx/config/nginx/scgi_params',
      require => File[$configdir];

    "${configdir}/uwsgi_params":
      ensure => $ensure,
      source => 'puppet:///modules/nginx/config/nginx/uwsgi_params',
      require => File[$configdir];
  }

  if $::osfamily == 'Darwin' {
    include boxen::config

    # Remove Homebrew's Nginx config to avoid confusion.
    file { "${boxen::config::homebrewdir}/etc/nginx":
      ensure  => absent,
      force   => true,
      recurse => true,
    }
  }

}
