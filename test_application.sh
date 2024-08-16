#!/bin/bash

# Namespace and label of your frontend pod
NAMESPACE="student-0"  # Replace with your namespace
LABEL_SELECTOR="app=frontend"  # Replace with your pod's label selector
SERVICE_NAME="frontend-service"  # Replace with your service name

# Get the pod's name (assuming there's only one pod with this label)
POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{.items[0].metadata.name}')

# Get the pod's IP
POD_IP=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.status.podIP}')

# Get the service's port (assuming the service exposes a single port)
SERVICE_PORT=30080

# Check if IP and Port were found
if [[ -z "$POD_IP" || -z "$SERVICE_PORT" ]]; then
  echo "Failed to retrieve Pod IP or Service Port"
  exit 1
fi

# Curl or ping the Service
echo "Curling service $SERVICE_NAME at $POD_IP:$SERVICE_PORT"
curl http://$POD_IP:$SERVICE_PORT

# Or use ping if you just want to check the connection
# echo "Pinging pod $POD_NAME at $POD_IP"
# ping -c 4 $POD_IP
