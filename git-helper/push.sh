#!/bin/sh

# When to use: Initialize and push all repository to the new Synology NAS Git server

protocol=ssh
id=?
ip=?
ssh_port=?
remote_path=?
remote_url=$protocol://$id@$ip:$ssh_port$remote_path

# Initialize remote Git directory if it doesn't exist
init_remote_dir() {
    ssh -p $ssh_port $id@$ip "if [ ! -d $1 ]; then git init --bare $1; fi"
}

dirs=$(ls -d */ | tr -d '/')
for dir in $dirs; do
    init_remote_dir $remote_path/$dir
    cd $dir
    git push --all $remote_url/$dir
    cd ..
done
