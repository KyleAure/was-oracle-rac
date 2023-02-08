#!/bin/bash

# This scripts allows us to do a sparse checkout of files from the oracle/docker-images repo
# Oracle does not provide prebuilt images for Oracle RAC so we have to do it ourselves

if [ $# -ne 5 ]; then
    echo "Not enough arguments provided"
    exit 1
fi

# The SSH url
url="$1" && shift
echo "url = $url"

# The name of the repo
repoName="$1" && shift
echo "repoName = $repoName"

## The clone location
localdir="$1" && shift
echo "localdir = $localdir"

## The project location
projectdir="$1" && shift
echo "projectdir = $projectdir"

## The sub directory to checkout
subdir="$1" && shift

## Create the local directory
if [ ! -d "$projectdir" ]; then
    mkdir -p "$localdir"
    mkdir -p "$projectdir"

    pushd "$localdir"
        git clone --no-checkout --depth 1 --sparse --filter=blob:none "$url"

        cd "$repoName"
        git sparse-checkout init --cone
        git sparse-checkout add $subdir

        git checkout main
        
        git status        
    popd

    cp -R "$localdir/$repoName/$subdir" "$projectdir"

else
    echo "$localdir already exists"
fi
