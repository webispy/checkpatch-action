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
pwd

RESULT=0

# Get PR number
PR=${GITHUB_REF#"refs/pull/"}
PRNUM=${PR%"/merge"}

# Get commit list using Github API
URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${PRNUM}/commits
list=$(curl $URL -X GET -s -H "Authorization: token ${GITHUB_TOKEN}" | jq '.[].sha' -r)
echo $list

# Run review.sh on each commit in the PR
for sha1 in $list; do
    echo "Check - Commit id $sha1"
    /review.sh ${sha1} || RESULT=1;
    echo "Result: ${RESULT}"
done

echo "Done"

exit $RESULT