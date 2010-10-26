POOL_NAME     = 'pegasus'
require File.dirname(__FILE__)+'/cloud_aspects'

#
# EBS-backed hadoop cluster in the cloud.
# See the ../README.textile file for usage, etc
# If you use the west coast availability zone, to avoid 'ami not found' errors, first run
#   export EC2_URL=https://us-west-1.ec2.amazonaws.com

pool POOL_NAME do

  #
  # Combined chef server, nfs server and hadoop master. Run this if you're just
  # starting out.
  #
  cloud :chefmaster do
    using :ec2
    settings = settings_for_node(POOL_NAME, :chefmaster)
    instances                   1
    is_generic_node             settings
    #is_nfs_server               settings
    is_chef_server              settings
    #
    is_hadoop_node              settings
    has_recipe                  settings, 'hadoop_cluster::format_namenode_once'
    has_role                    settings, "hadoop_master"
    has_role                    settings, "hadoop_worker"
    has_recipe                  settings, 'hadoop_cluster::std_hdfs_dirs'
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_bootstrap_script(settings, 'bootstrap_chef_server')
  end

  cloud :cassandra_node do
    using :ec2
    settings = settings_for_node(POOL_NAME, :cassandra_node)
    instances                   (settings[:instances] || 2)
    instance_type               settings
    is_generic_node             settings
    is_chef_client              settings
    user_data_is_json_hash      settings
    is_cassandra_node           settings
    #
    #is_hadoop_node              settings
    #has_recipe                  settings, 'hadoop_cluster::format_namenode_once'
    #has_role                    settings, "hadoop_master"
    #has_role                    settings, "hadoop_worker"
    #has_recipe                  settings, 'hadoop_cluster::std_hdfs_dirs'
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_bootstrap_script(settings, 'bootstrap_chef_client')
  end

  #
  # Hadoop master, to be used with a standalone chef server and (optional) nfs server.
  #
  cloud :master do
    using :ec2
    settings = settings_for_node(POOL_NAME, :master)
    instances                   1
    # Order matters here: specifically, attaches_ebs > nfs_client > most things
    is_generic_node             settings
    #is_nfs_client               settings
    is_chef_client              settings
    #
    is_hadoop_node              settings
    has_recipe                  settings, 'hadoop_cluster::format_namenode_once'
    has_role                    settings, "hadoop_master"
    has_role                    settings, "hadoop_worker"
    has_recipe                  settings, 'hadoop_cluster::std_hdfs_dirs'
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_bootstrap_script(settings, 'bootstrap_chef_client')
  end

  cloud :slave do
    using :ec2
    settings = settings_for_node(POOL_NAME, :slave)
    instances                   (settings[:instances] || 3)
    #
    is_generic_node             settings
    #is_nfs_client               settings
    is_chef_client              settings
    #
    is_hadoop_node              settings
    has_role                    settings, "hadoop_worker"
    #
    has_big_package             settings
    has_role                    settings, "#{POOL_NAME}_cluster"
    user_data_is_bootstrap_script(settings, 'bootstrap_chef_client')
  end
end
