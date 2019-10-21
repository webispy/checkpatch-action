#!/usr/bin/env bash

echo "Start..."
echo "Workflow: $GITHUB_WORKFLOW"
echo "Action: $GITHUB_ACTION"
echo "Actor: $GITHUB_ACTOR"
echo "Repository: $GITHUB_REPOSITORY"
echo "Event-name: $GITHUB_EVENT_NAME"
echo "Event-path: $GITHUB_EVENT_PATH"
echo "Workspace: $GITHUB_WORKSPACE"
echo "SHA: $GITHUB_SHA"
echo "REF: $GITHUB_REF"
echo "HEAD-REF: $GITHUB_HEAD_REF"
echo "BASE-REF: $GITHUB_BASE_REF"
echo "TOKEN: $GITHUB_TOKEN"
pwd


for sha1 in $(git rev-list $GITHUB_SHA^..$GITHUB_SHA); do
    echo "Commit id $sha1"
    #git show --format=email $sha1 | checkpatch.pl -q --no-tree -
done

PR=${GITHUB_REF#"refs/pull/"}
PRNUM=${PR%"/merge"}
RESULT=0

echo ${PR}
echo ${PRNUM}

for sha1 in $(git rev-list origin/$GITHUB_BASE_REF..origin/$GITHUB_HEAD_REF); do
    echo "Check - Commit id $sha1"
    /review.sh ${sha1} ${PRNUM} ${GITHUB_TOKEN} || RESULT=1;
    echo "Result: ${RESULT}"
done

#URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${PRNUM}/comments
#curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
#    -X POST -d '{ "body": "hi" }' \
#    $URL

echo "Done"

exit $RESULT