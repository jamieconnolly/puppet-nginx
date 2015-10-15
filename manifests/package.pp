# Internal: Install the nginx package

class nginx::package(
  $ensure  = undef,
  $package = undef,
  $version = undef,
) {

  $package_ensure = $ensure ? {
    present => $version,
    default => absent,
  }

  if $::osfamily == 'Darwin' {
    require homebrew

    homebrew::formula { 'nginx':
      before => Package[$package]
    }
  }

  package { $package:
    ensure => $package_ensure
  }

}
