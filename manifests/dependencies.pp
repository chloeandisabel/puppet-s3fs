class s3fs::dependencies {

  if ! defined(Package['build-essential'])      { package { 'build-essential':      ensure => installed } }
  if ! defined(Package['libfuse-dev'])          { package { 'libfuse-dev':          ensure => installed } }
  if ! defined(Package['fuse-utils'])           { package { 'fuse-utils':           ensure => installed } }
  if ! defined(Package['libcurl4-openssl-dev']) { package { 'libcurl4-openssl-dev': ensure => installed } }
  if ! defined(Package['libxml2-dev'])          { package { 'libxml2-dev':          ensure => installed } }
  if ! defined(Package['mime-support'])         { package { 'mime-support':         ensure => installed } }

}
