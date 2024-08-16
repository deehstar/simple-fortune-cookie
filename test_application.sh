#!/bin/bash

NAMESPACE="student-0"
LABEL_SELECTOR="app=frontend"  
SERVICE_NAME="frontend-service" 


POD_NAME=$(kubectl get pods -n $NAMESPACE -l $LABEL_SELECTOR -o jsonpath='{.items[0].metadata.name}')


POD_IP=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.status.podIP}')


SERVICE_PORT=$(kubectl get svc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.ports[0].port}')


if [[ -z "$POD_IP" || -z "$SERVICE_PORT" ]]; then
  echo "Failed to retrieve Pod IP or Service Port"
  exit 1
fi

echo "Curling service $SERVICE_NAME at $POD_IP:$SERVICE_PORT"
curl http://$POD_IP:$SERVICE_PORT
