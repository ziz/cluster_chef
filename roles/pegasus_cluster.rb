name        'pegasus_cluster'
description 'Holds cluster-specific overrides and recipes for the pegasus_cluster'

run_list *%w[
  ]

# Force these attributes overriding all else
override_attributes({
    :cluster_size => 4,
  })

# Attributes applied if the node doesn't have it set already.
default_attributes({
  })
