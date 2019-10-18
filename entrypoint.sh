#!/usr/bin/env bash

echo "Start..."
echo "$GITHUB_WORKSPACE"
echo "$GITHUB_REF"
echo "$GITHUB_SHA"
pwd


for sha1 in $(git rev-list HEAD); do
    echo "Commit id $sha1"
    #git show --format=email $sha1 | checkpatch.pl -q --no-tree -
done

echo "Done"
