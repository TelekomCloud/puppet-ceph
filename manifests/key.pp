 #
define ceph::key (
  $secret       = undef,
  $secret_file  = false,
  $keyring_path = "/var/lib/ceph/tmp/${name}.keyring",
  $user         = 'root',
  $group        = 'root',
  $mode         = '0600',
) {

  if $secret_file == false {
    exec { "ceph-key-${name}":
      command => "ceph-authtool ${keyring_path} --create-keyring --name='client.${name}' --add-key='${secret}'",
      creates => $keyring_path,
      require => Package['ceph'],
    }

    file { "${keyring_path}":
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => $mode,
      require => Exec["ceph-key-${name}"]
    }
  } else {
      exec { "ceph-key-${name}":
        command => "ceph-authtool ${keyring_path} --create-keyring --name='client.${name}' --add-key=$(cat ${secret})",
        creates => $keyring_path,
        require => [Package['ceph'],File["${secret}"],],
      }

      file { "${keyring_path}":
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => $mode,
        source  => $keyring_path,
        require => Exec["ceph-key-${name}"]
      }
    }
}
