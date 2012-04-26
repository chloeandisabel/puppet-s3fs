define s3fs::mount ($bucket,
                    $mount_point,
                    $s3url = 'https://s3.amazonaws.com',
                    $default_acl = 'private',
                    $user = 'root',
                    $group = 'root',
                    $uid = '0',
                    $gid = '0'
                    ) {

  require s3fs

  file {$mount_point:
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  mount{$mount_point:
    ensure   => mounted,
    atboot   => true,
    device   => "s3fs#${bucket}",
    fstype   => 'fuse',
    options  => "allow_other,uid=${uid},gid=${gid},default_acl=${default_acl},use_cache=/tmp/aws_s3_cache,url=${s3url}",
    require  => File [$mount_point],
    remounts => false,
  }
#options => "defaults,noatime,allow_other,uid=48,gid=48,use_cache=/tmp,default_acl=public-read,url=http://s3-eu-west-1.amazonaws.com",

}

