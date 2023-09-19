#!/bin/bash

echo "### Connecting a service to envoy! ###"
echo ""
read -p "What's service's name you want to connect? (ex. git) " name
read -p "What port number does it use? (ex. 12345) " port
read -p "What path you want to use? (ex. git) " path
echo "You can access https://IP-address/$path or https://my-id.route-ddns.com/$path after this procedure"
echo ""

echo "Service name: $name"
echo "Port: $port"
echo "Path: $path"
read -p "Are you OK to proceed? (y/n) " go
echo ""

if [ "$go" = "y" ]; then

  echo "Checking..."
  grep $name ./envoy/cds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same name! Please check it out first"
    exit 1
  fi
  grep $port ./envoy/cds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same port! Please check it out first"
    exit 1
  fi
  grep $name ./envoy/lds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same name! Please check it out first"
    exit 1
  fi
  grep $port ./envoy/lds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same port! Please check it out first"
    exit 1
  fi
  grep $path ./envoy/lds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same path! Please check it out first"
    exit 1
  fi
  echo "Done"
  echo ""

  echo "Appending..."
  c_num=$(find ./envoy/cds/clusters -type f | wc -l)
  c_fname=$(printf "%02d-cluster.yaml" $c_num)
  sed "s/\$domain/$name/; s/\$port/$port/" \
    ./envoy/cds/cluster-template.yaml > ./envoy/cds/clusters/$c_fname
  h_num=$(find ./envoy/lds/hosts -type f | wc -l)
  h_fname=$(printf "%02d-host.yaml" $h_num)
  sed "s/\$domain/$name/; s#\$prefix#"/$path"#" \
    ./envoy/lds/host-template.yaml > ./envoy/lds/hosts/$h_fname
  echo "Done"
  echo ""

  echo "Applying..."
  pushd .
  cd ./envoy/cds/
  sh ./apply.sh
  popd
  pushd .
  cd ./envoy/lds/
  sh ./apply.sh
  popd
  echo "Done"
  echo ""
  
elif [ "$go" = "n" ]; then
  echo "Cancelled"
fi

