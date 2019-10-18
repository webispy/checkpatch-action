#!/usr/bin/env bash

echo "Start..."
echo "$GITHUB_WORKSPACE"
echo "$GITHUB_REF"
echo "$GITHUB_SHA"

for sha1 in $(git rev-list master..); do
    echo "Commit id $sha1"
done

echo "Done"
