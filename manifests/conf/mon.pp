define ceph::conf::mon (
  $mon_addr,
  $mon_port,
  $mon_cluster_log_to_file,
  $mon_cluster_log_to_syslog,
) {

  @@concat::fragment { "ceph-mon-${name}.conf":
    target  => '/etc/ceph/ceph.conf',
    order   => '50',
    content => template('ceph/ceph.conf-mon.erb'),
  }

}
