#!/bin/sh
cat hosts/* > lds.yaml
ln -s lds.yaml temp
mv -Tf temp cur.yaml
