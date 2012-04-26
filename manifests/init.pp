# Class: s3fs
#
# This module manages vladgh-s3fs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  # S3FS
#  s3fs::mount {'Testing':
#    bucket      => 'testvgh1',
#    mount_point => '/srv/testvgh1',
#    user        => 'vlad',
#    group       => 'vlad',
#    uid         => '1001',
#    gid         => '1001',
#  }
#  ## S3FS
#  s3fs::mount {'Testvgh':
#    bucket      => 'testvgh',
#    mount_point => '/srv/testvgh2',
#    default_acl => 'public-read',
#  }
#
class s3fs {

  require common::repos
  require s3fs::params

  $aws_access_key_id     = hiera('aws_access_key_id')
  $aws_secret_access_key = hiera('aws_secret_access_key')
  $credentials           = inline_template("<%= aws_access_key_id %>:<%= aws_secret_access_key %>")

  package{'S3FS Package':
    ensure => present,
    name   => $s3fs::params::s3fs_package,
  }

  file{'S3FS Credentials':
    ensure  => present,
    path    => $s3fs::params::credentials_file,
    content => $credentials,
    require => Package ['S3FS Package'],
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

}
