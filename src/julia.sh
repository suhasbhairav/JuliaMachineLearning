#!/bin/bash

if [[ `uname` == 'Darwin' ]]; then
    DIR=/Users/alex/tmp/adagram/AdaGram.jl
	DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$DIR/lib julia "$@"
elif [[ `uname` == 'Linux' ]]; then
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DIR/lib julia "$@"
fi

