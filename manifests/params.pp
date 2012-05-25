class s3fs::params {

  $credentials_file = '/etc/passwd-s3fs'
  $download_dir       = '/tmp'
  $download_url     = 'http://s3fs.googlecode.com/files'

  # Fail if the OS is not Ubuntu/Debian
  case $::operatingsystem {
    ubuntu, debian: {
    }
    default: {
      fail("Unsupported platform: ${::operatingsystem}")
    }
  }

  $s3fs_package = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => 's3fs',
    default                 => fail("${::operatingsystem} not supported")
  }

  # s3fs version >1.19 requires fuse > 2.8.4 which is installed on >10.10
  case $::lsbdistdescription {
    'Ubuntu 10.10': {
      $version = '1.61'
    }
    default: {
      $version = '1.19'
    }
  }

}
