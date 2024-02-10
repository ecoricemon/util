#!/bin/sh
cat clusters/* > cds.yaml
ln -s cds.yaml temp
mv -Tf temp cur.yaml
