name        'cassandra_client'
description 'Part of a cassandra database'

run_list *%w[
  java::sunjava
  runit
  boost
  thrift
  python
  cassandra
  cassandra::install_from_git
  ]

# Attributes applied if the node doesn't have it set already.
default_attributes({
  })

# Attributes applied if the node doesn't have it set already.
override_attributes({
    :cassandra => {
      :auto_bootstrap    => true,
      :jmx_port          => 12345,
      :concurrent_reads  => 4,
      :concurrent_writes => 64,
      :commitlog_sync    => 'periodic',
      :data_file_dirs    => ["/data/db/cassandra"],
    }
  })

