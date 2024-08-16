#!/bin/bash

# Namespace and service name
NAMESPACE="student-0"  # Replace with your namespace
LABEL_SELECTOR="app=frontend"  # Replace with your pod's label selector
SERVICE_NAME="frontend-service"  # Replace with your service name

echo "Checking Kubernetes Resources in Namespace: $NAMESPACE"
kubectl get all -n $NAMESPACE

# Get the service's cluster IP
SERVICE_IP=$(kubectl get svc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.clusterIP}' 2>/dev/null)

# Service port as defined in the service YAML
SERVICE_PORT=$(kubectl get svc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)

# Check if Service IP and Port were found
if [[ -z "$SERVICE_IP" || -z "$SERVICE_PORT" ]]; then
  echo "Failed to retrieve Service IP or Service Port for $SERVICE_NAME in namespace $NAMESPACE"
  echo "Please check if the service exists and is correctly configured."
  echo "Resources in namespace $NAMESPACE:"
  kubectl get all -n $NAMESPACE
  exit 1
fi

# Get the pod's name (assuming there's only one pod with this label)
POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

# Check if Pod Name was found
if [[ -z "$POD_NAME" ]]; then
  echo "Failed to retrieve Pod Name with label $LABEL_SELECTOR in namespace $NAMESPACE"
  echo "Please check if the pod exists and is correctly labeled."
  echo "Resources in namespace $NAMESPACE:"
  kubectl get all -n $NAMESPACE
  exit 1
fi

# Get the pod's IP
POD_IP=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.status.podIP}' 2>/dev/null)

# Check if Pod IP was found
if [[ -z "$POD_IP" ]]; then
  echo "Failed to retrieve Pod IP for pod $POD_NAME in namespace $NAMESPACE"
  echo "Please check the pod status."
  echo "Resources in namespace $NAMESPACE:"
  kubectl get all -n $NAMESPACE
  exit 1
fi

# Curl the Service using the Service IP and Port
echo "Curling service $SERVICE_NAME at $SERVICE_IP:$SERVICE_PORT"
curl -v http://$SERVICE_IP:$SERVICE_PORT || { echo "Curl failed"; exit 1; }

# Provide detailed service information
echo "Service Details:"
kubectl describe svc $SERVICE_NAME -n $NAMESPACE

# Provide detailed pod information
echo "Pod Details:"
kubectl describe pod $POD_NAME -n $NAMESPACE
# Some comment
