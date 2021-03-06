POOL_NAME     = 'gibbon'
require File.dirname(__FILE__)+'/cloud_aspects'

#
# EBS-backed hadoop cluster in the cloud.
# See the ../README.textile file for usage, etc
# If you use the west coast availability zone, to avoid 'ami not found' errors, first run
#   export EC2_URL=https://us-west-1.ec2.amazonaws.com

pool POOL_NAME do

  #
  # Hadoop master, to be used with a standalone chef server and (optional) nfs server.
  # Uses a persistent HDFS on ebs volumes, and runs cassandra on each node.
  #
  cloud :master do
    using :ec2
    settings = settings_for_node(POOL_NAME, :master)
    instances                   1
    #
    attaches_ebs_volumes        settings
    is_generic_node             settings
    is_nfs_client               settings
    is_chef_client              settings
    has_role                    settings, "infochimps_base"
    has_role                    settings, "azkaban"
    mounts_ebs_volumes          settings
    #
    is_hadoop_node              settings
    has_role                    settings, "hadoop_master"
    has_role                    settings, "hadoop_worker"
    # is_cassandra_node         settings
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_json_hash      settings
  end

  cloud :slave do
    using :ec2
    settings = settings_for_node(POOL_NAME, :slave)
    instances                   (settings[:instances] || 5)
    #
    attaches_ebs_volumes        settings
    is_generic_node             settings
    is_nfs_client               settings
    is_chef_client              settings
    has_role                    settings, "infochimps_base"
    mounts_ebs_volumes          settings
    #
    is_hadoop_node              settings
    has_role                    settings, "hadoop_worker"
    # is_cassandra_node         settings
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_json_hash      settings
  end
end
