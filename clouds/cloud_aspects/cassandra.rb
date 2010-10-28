#
# Cassandra aspects for poolparty and chef
#

def is_cassandra_node settings
  has_role settings, "cassandra_node"
  security_group 'cassandra_node' do
    authorize :group_name => 'cassandra_node'
    authorize :network => '70.91.172.41/29', :from_port => "9160", :to_port => "9160"
    authorize :network => '72.32.68.18/32', :from_port => "9160", :to_port => "9160"
  end
end
