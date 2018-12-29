#!/bin/sh
if [ ! -d "./out" ]; then
mkdir ./out
fi
make #ARCH=arm OS=linux
