URL="http://localhost:8080"

kubectl port-forward svc/frontend-service 8080:8080 &
kubectl port-forward svc/backend-service 9000:9000 &
kubectl port-forward svc/redis-service 6379:6379 &

sleep 5

HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

if [ "$HTTP_RESPONSE" -eq 200 ]; then
  echo "Application is up and running."
  exit 0
else
  echo "Application is not available. HTTP response code: $HTTP_RESPONSE"
  exit 1
fi