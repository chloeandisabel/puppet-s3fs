class s3fs::config (
  credentials       = inline_template("<%= aws_access_key_id %>:<%= aws_secret_access_key %>"),
  $credentials_file = $s3fs::params::credentials_file
) inherits s3fs::params {

  file{ 's3fs_credentials':
    ensure  => $ensure,
    path    => $credentials_file,
    content => $credentials,
    require => Package ['S3FS Package'],
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

}
