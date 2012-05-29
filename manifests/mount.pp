# Class: s3fs::mount
#
# This module installs s3fs
#
# Parameters:
#
#  [*bucket*]      - AWS bucket name
#  [*mount_point*] - Mountpoint for bucket
#  [*ensure*]      - Set mountpoint values, ensure dir and mount are absent
#  [*s3url*]       - 'https://s3.amazonaws.com'
#  [*default_acl*] - 'private'
#  [*uid*]         - Mountpoint and mount dir owner
#  [*gid*]         - Mountpoint and mount dir group
#  [*mode*]        - Mountpoint and moutn dir permissions
#  [*atboot*]      - 'true',
#  [*device*]      - "s3fs#${bucket}",
#  [*fstype*]      - 'fuse',
#  [*options*]     - "allow_other,uid=${uid},gid=${gid},default_acl=${default_acl},use_cache=/tmp/aws_s3_cache,url=${s3url}",
#  [*remounts*]    - 'false',
#
# Actions:
#
# Requires:
#  Class['s3fs']
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
define s3fs::mount (
  $bucket,
  $mount_point,
  $ensure      = 'present',
  $s3url       = 'https://s3.amazonaws.com',
  $default_acl = 'private',
  $uid         = '0',
  $gid         = '0',
  $mode        = '0660',
  $atboot      = 'true',
  $device      = "s3fs#${bucket}",
  $fstype      = 'fuse',
  $remounts    = 'false',
  $cache       = '/tmp/aws_s3_cache'
) {

  Class['s3fs'] -> S3fs::Mount["${name}"]

  # Declare this here, otherwise, uid, guid, etc.. are not initialized in the correct order.
  $options = "allow_other,uid=${uid},gid=${gid},default_acl=${default_acl},use_cache=${cache},url=${s3url}"

  case $ensure {
    present, defined, unmounted, mounted: {
      $ensure_dir = 'directory'
    }
    absent: {
      $ensure_dir = 'absent'
    }
    default: {
      fail("Not a valid ensure value: ${ensure}")
    }
  }

  File["${mount_point}"] -> Mount["${mount_point}"]

  file { $mount_point:
    ensure  => $ensure_dir,
    recurse => true,
    force   => true,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }

  mount{ $mount_point:
    ensure   => $ensure,
    atboot   => $atboot,
    device   => $device,
    fstype   => $fstype,
    options  => $options,
    remounts => $remounts,
  }

}
