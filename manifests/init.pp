# Public: Install and configure Nginx from Homebrew
#
# Usage
#
#   include nginx
#

class nginx(
  $ensure     = present,
  $configdir  = undef,
  $datadir    = undef,
  $enable     = undef,
  $executable = undef,
  $logdir     = undef,
  $package    = undef,
  $service    = undef,
  $sitesdir   = undef,
  $user       = undef,
  $version    = undef,
) {

  validate_string(
    $ensure,
    $configdir,
    $datadir,
    $executable,
    $logdir,
    $package,
    $service,
    $sitesdir,
    $user,
    $version,
  )
  validate_bool($enable)

  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  class { 'nginx::config':
    ensure     => $ensure,
    configdir  => $configdir,
    datadir    => $datadir,
    logdir     => $logdir,
    sitesdir   => $sitesdir,
    user       => $user,
  }

  ~>
  class { 'nginx::package':
    ensure     => $ensure,
    package    => $package,
    version    => $version,
  }

  ~>
  class { 'nginx::service':
    ensure     => $ensure,
    configdir  => $configdir,
    datadir    => $datadir,
    enable     => $enable,
    executable => $executable,
    logdir     => $logdir,
    service    => $service,
    user       => $user,
  }

}
