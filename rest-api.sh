#!/bin/bash

PORT="${PORT:-8080}"

handle_request() {
  local request_line method path body status header cmd cmd_output cmd_escaped output_escaped path_escaped

  IFS= read -r request_line || request_line=""
  request_line="${request_line%$'\r'}"
  echo "Request: $request_line" >&2

  # Read headers until blank line
  while IFS= read -r header; do
    header="${header%$'\r'}"
    [ -z "$header" ] && break
  done

  method="${request_line%% *}"
  path="${request_line#* }"
  path="${path%% *}"

  if [[ "$method" == "GET" && "$path" == "/hello" ]]; then
    body='{"message":"Hello from simple Rest API in Bash"}'
    status="200 OK"
  elif [[ "$method" == "GET" && "$path" == "/time" ]]; then
    body="{\"time\":\"$(date)\"}"
    status="200 OK"
  elif [[ "$method" == "GET" && "$path" == "/hostname" ]]; then
    body="{\"hostname\":\"$(hostname)\"}"
    status="200 OK"
  else
    body='{"error":"Not found"}'
    status="404 Not Found"
  fi

  printf 'HTTP/1.1 %s\r\n' "$status"
  printf 'Content-Type: application/json; charset=utf-8\r\n'
  printf 'Content-Length: %s\r\n' "${#body}"
  printf 'Connection: close\r\n'
  printf '\r\n'
  printf '%s' "$body"
}

if [[ "${1:-}" == "--handle" ]]; then
  handle_request
else
  exec socat "TCP-LISTEN:${PORT},reuseaddr,fork" SYSTEM:"$0 --handle"
fi
