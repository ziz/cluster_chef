name        'base_role'
description 'top level attributes, applies to all nodes'

run_list *%w[
  base
  aws
  ubuntu
  java
  python
  ]

# Attributes applied if the node doesn't have it set already.
default_attributes({
    :cluster_size => 5,
  })
