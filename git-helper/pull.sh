#!/bin/sh

# When to use: Mirroring

# Pull all branches from exisiting copy
pull() {
    echo $1
    local=$(git branch --format "%(upstream)" | sed "s#refs/remotes/##")
    for br in $(git branch -r | grep -v $local 2> /dev/null); do
      git branch -t ${br#*/} $br;
    done
    git pull --all
}

dirs=$(ls -d */)
for dir in $dirs; do
    cd $dir
    pull $remote_url/$dir
    cd ..
done
