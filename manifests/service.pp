# Internal: Manage the nginx service

class nginx::service(
  $ensure     = undef,
  $configdir  = undef,
  $datadir    = undef,
  $enable     = undef,
  $executable = undef,
  $logdir     = undef,
  $service    = undef,
  $user       = undef,
) {

  $service_ensure = $ensure ? {
    present => running,
    default => stopped,
  }

  if $::osfamily == 'Darwin' {
    file { "/Library/LaunchDaemons/${service}.plist":
      ensure  => $ensure,
      content => template('nginx/dev.nginx.plist.erb'),
      group   => 'wheel',
      owner   => 'root',
      before  => Service[$service],
    }
  }

  service { $service:
    ensure => $service_ensure,
    enable => $enable,
    alias  => 'nginx',
  }

}
