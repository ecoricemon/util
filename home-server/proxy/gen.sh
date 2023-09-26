#!/bin/bash

echo "### Connecting a service to envoy! ###"
echo ""
read -p "Which service do you want to connect? (ex. git) " name
read -p "What port number does it use? (ex. your.port.number.0005) " port
echo "You can access https://IP-address/$path or https://my-id.router.ddns.com/$path after this procedure"
echo ""

echo "Service name: $name"
echo "Port: $port"
read -p "Are you OK to proceed? (y/n) " go
echo ""

if [ "$go" = "y" ]; then

  echo "Checking..."
  grep $name ./volume/envoy/cds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same name! Please check it out first"
    exit 1
  fi
  grep $port ./volume/envoy/cds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same port! Please check it out first"
    exit 1
  fi
  grep $name ./volume/envoy/lds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same name! Please check it out first"
    exit 1
  fi
  grep $port ./volume/envoy/lds/cur.yaml
  if [ $? -eq 0 ]; then
    echo "[ERROR] There is a service with the same port! Please check it out first"
    exit 1
  fi
  echo "Done"
  echo ""

  echo "Appending..."

  # === CDS ===
  c_num=$(find ./volume/envoy/cds/clusters -type f | wc -l)
  c_fname=$(printf "%02d-cluster.yaml" $c_num)
  sed "s/\$domain/$name/; s/\$port/$port/" \
    ./volume/envoy/cds/cluster-template.yaml > ./volume/envoy/cds/clusters/$c_fname

  # === LDS ===
  h_num=$(find ./volume/envoy/lds/hosts -type f | wc -l)
  h_fname=$(printf "%02d-host.yaml" $h_num)
  sed "s/\$domain/$name/; s/\$external/$name.your.domain.name/" \
    ./volume/envoy/lds/host-template.yaml > ./volume/envoy/lds/hosts/$h_fname

  echo "Done"
  echo ""

  echo "Applying..."
  pushd .
  cd ./volume/envoy/cds/
  sh ./apply.sh
  popd
  pushd .
  cd ./volume/envoy/lds/
  sh ./apply.sh
  popd
  echo "Done"
  echo ""
  
elif [ "$go" = "n" ]; then
  echo "Cancelled"
fi

