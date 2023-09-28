#!/bin/bash



# Define variables

NEW_NODE_COUNT=${NEW_NODE_COUNT}

NEW_NODE_CPU=${NEW_NODE_CPU}

NEW_NODE_MEMORY=${NEW_NODE_MEMORY}



# Add new nodes

for ((i=1; i<=$NEW_NODE_COUNT; i++))

do

  # Run etcdctl command to add new node

  etcdctl member add node$i --peer-urls=http://node$i:2380

done



# Update CPU and memory on existing nodes

for NODE in $(etcdctl member list | awk '{print $2}')

do

  # Run etcdctl command to update CPU and memory for node

  etcdctl member update $NODE --peer-urls=http://$NODE:2380 --client-urls=http://$NODE:2379 --node-cpu=$NEW_NODE_CPU --node-memory=$NEW_NODE_MEMORY

done



echo "Etcd cluster resources have been increased."