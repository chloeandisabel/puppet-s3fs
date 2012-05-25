# Class: s3fs
#
# This module installs s3fs
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# # S3FS
#  s3fs::mount {'Testing':
#    bucket      => 'testvgh1',
#    mount_point => '/srv/testvgh1',
#    uid         => '1001',
#    gid         => '1001',
#  }
# ## S3FS
#  s3fs::mount {'Testvgh':
#    bucket      => 'testvgh',
#    mount_point => '/srv/testvgh2',
#    default_acl => 'public-read',
#  }
#
#  $aws_access_key_id     = hiera('aws_access_key_id'),
#  $aws_secret_access_key = hiera('aws_secret_access_key')
class s3fs (
  $ensure                = 'present',
  $s3fs_package          = $s3fs::params::s3fs_package,
  $source_dir            = $s3fs::params::source_dir,
  $version               = $s3fs::params::version,
  $download_url          = $s3fs::params::download_url,
  $aws_access_key_id,
  $aws_secret_access_key
) inherits s3fs::params {

  Class['s3fs::dependencies'] -> Class['s3fs']
  include s3fs::dependencies

/*
  package{'S3FS Package':
    ensure => $ensure,
    name   => $s3fs_package,
  }
*/

  Exec['s3fs_tar_gz'] ~> Exec['s3fs_extract'] ~> Exec['s3fs_configure'] ~> Exec['s3fs_make'] ~> Exec['s3fs_install']

  # Distribute s3fs source from within module to control version (could
  # also download from Google directly):
  exec { 's3fs_tar_gz':
    creates   => "${source_dir}/s3fs-${version}.tar.gz",
    command   => "curl -o ${source_dir}/s3fs-${version}.tar.gz ${download_url}",
    logoutput => true,
    timeout   => 300,
    path      => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin',
    unless    => 's3fs --version | grep ${version}'
  }
  
  # Extract s3fs source:
  exec { 's3fs_extract':
    creates   => "${source_dir}/s3fs-${version}",
    command   => "tar --no-same-owner -xzf /root/s3fs-$version.tar.gz --directory ${source_dir}",
    logoutput => true,
    timeout   => 300,
    path      => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin',
  }

  # Configure s3fs build:
  exec { 's3fs_configure':
    creates     => "${source_dir}/s3fs-${version}/config.status",
    cwd         => "${source_dir}/s3fs-${version}",
    command     => "${source_dir}/s3fs-${version}/configure --program-suffix=-${version}",
    logoutput   => true,
    timeout     => 300,
    refreshonly => true,
  }

  # Build s3fs:
  exec { 's3fs_make':
    creates     => "${source_dir}/s3fs-${version}/src/s3fs",
    cwd         => "${source_dir}/s3fs-${version}",
    command     => "/usr/bin/make",
    logoutput   => true,
    timeout     => 300,
    refreshonly => true,
  }
  
  # Install s3fs
  exec { 's3fs_install':
    command     => "/usr/bin/make install",
    logoutput   => true,
    timeout     => 300,
    refreshonly => true,
  }
  
}
