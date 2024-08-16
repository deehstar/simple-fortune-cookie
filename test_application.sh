url1="http://localhost:9000"
url2="http://localhost:8080"

check_url() {
    if curl -s --head "$1" | grep "200 OK" > /dev/null; then
        echo "$1 is reachable."
    else
        echo "$1 is not reachable."
    fi
}

check_url "$url1"
check_url "$url2"
