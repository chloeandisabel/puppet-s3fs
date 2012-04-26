class s3fs::params {

  $credentials_file = '/etc/passwd-s3fs'

  $s3fs_package = $::operatingsystem ? {
    /(?i-mx:debian|ubuntu)/ => 's3fs',
    default                 => fail("${::operatingsystem} not supported")
  }

}

