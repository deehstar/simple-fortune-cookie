URL="http://localhost:30080"

HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

if [ "$HTTP_RESPONSE" -eq 200 ]; then
  echo "Application is up and running."
  exit 0
else
  echo "Application is not available. HTTP response code: $HTTP_RESPONSE"
  exit 1
fi
