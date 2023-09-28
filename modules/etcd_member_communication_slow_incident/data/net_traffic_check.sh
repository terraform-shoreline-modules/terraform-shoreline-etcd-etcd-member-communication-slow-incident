

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