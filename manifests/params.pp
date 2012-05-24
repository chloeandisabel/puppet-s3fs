class s3fs::params {

  $credentials_file = '/etc/passwd-s3fs'
  $source_dir       = '/root'
  $download_url     = 'http://s3fs.googlecode.com/files'

  # s3fs version >1.19 requires fuse > 2.8.4:

  $s3fs_package = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => 's3fs',
    default                 => fail("${::operatingsystem} not supported")
  }

  case $::operatingsystem {
    ubuntu, debian: {
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

  case $::lsbdistdescription {
    'Ubuntu 10.10': {
      $version = '1.61'
    }
    default: {
      $version = '1.19'
    }
  }

}

