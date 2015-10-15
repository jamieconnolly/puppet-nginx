# nginx Puppet Module for Boxen
[![Build Status](https://travis-ci.org/boxen/puppet-nginx.svg)](https://travis-ci.org/boxen/puppet-nginx)

## Usage

```puppet
include nginx
```

This module supports data bindings via hiera. See the parameters to the nginx
class for overridable values.

## Required Puppet Modules

* `boxen`
* `homebrew`
* `ripienaar/puppet-module-data`
* `stdlib`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
