
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Etcd member communication slow incident.
---

This incident type refers to an issue where communication between Etcd members is slowing down, resulting in a decrease in the performance of the Etcd system. The incident is triggered when the 99th percentile of communication time exceeds 0.15 seconds. This type of incident can impact the functionality and stability of the Etcd system, and requires immediate attention to restore normal operation.

### Parameters
```shell
export ETCD_ENDPOINTS="PLACEHOLDER"

export NETWORK_INTERFACE="PLACEHOLDER"

export ETCD_MEMBER_IP="PLACEHOLDER"

export ETCD_MEMBERS_LIST="PLACEHOLDER"

export ETCD_PORT="PLACEHOLDER"

export NEW_NODE_MEMORY="PLACEHOLDER"

export NEW_NODE_COUNT="PLACEHOLDER"

export NEW_NODE_CPU="PLACEHOLDER"
```

## Debug

### Check if the Etcd service is running
```shell
systemctl status etcd
```

### Check the logs for the Etcd service
```shell
journalctl -u etcd
```

### Check Etcd cluster health
```shell
etcdctl cluster-health
```

### Check the health of each Etcd member
```shell
etcdctl endpoint health
```

### Check the network latency between Etcd members
```shell
etcdctl --endpoints=${ETCD_ENDPOINTS} endpoint status --write-out=table
```

### Check the CPU and memory usage of Etcd processes
```shell
ps aux | grep etcd
```

### Check the network traffic between Etcd members
```shell
tcpdump -i ${NETWORK_INTERFACE} port 2379
```

### Check the network bandwidth between the Etcd members
```shell
iperf -c ${ETCD_MEMBER_IP}
```

### Check the firewall rules for Etcd ports
```shell
iptables -L | grep 2379
```

### Check the configuration file for Etcd
```shell
cat /etc/etcd/etcd.conf
```

### High network traffic between etcd cluster members.
```shell


#!/bin/bash



# Define variables

ETCD_MEMBERS=${ETCD_MEMBERS_LIST}

ETCD_PORT=${ETCD_PORT}



# Check network traffic

for member in ${ETCD_MEMBERS}; do

    traffic=$(netstat -an | grep ${member}:${ETCD_PORT} | awk '{print $2}')



    if [ -n "${traffic}" ]; then

        echo "High network traffic detected on ${member}:${ETCD_PORT} (${traffic} connections)"

    else

        echo "No network traffic detected on ${member}:${ETCD_PORT}"

    fi

done


```

## Repair

### Increase the resources allocated to the Etcd cluster by adding more nodes or increasing the CPU and memory on the existing nodes.
```shell
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


```