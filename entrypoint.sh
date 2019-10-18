#!/usr/bin/env bash

echo "Start..."
echo "Workspace: $GITHUB_WORKSPACE"
echo "REF: $GITHUB_REF"
echo "HEAD-REF: $GITHUB_HEAD_REF"
echo "BASE-REF: $GITHUB_BASE_REF"
echo "SHA: $GITHUB_SHA"
pwd


for sha1 in $(git rev-list $GITHUB_SHA^..$GITHUB_SHA); do
    echo "Commit id $sha1"
    #git show --format=email $sha1 | checkpatch.pl -q --no-tree -
done

echo "Check-2"

for sha1 in $(git rev-list origin/$GITHUB_BASE_REF..origin/$GITHUB_HEAD_REF); do
    echo "Commit id $sha1"
    git show --format=email $sha1 | checkpatch.pl -q --no-tree -
done

echo "Done"
