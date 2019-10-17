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

RESULT=0

# Run review.sh on each commit in the PR
for sha1 in $(git rev-list origin/$GITHUB_BASE_REF..origin/$GITHUB_HEAD_REF); do
    echo "Check - Commit id $sha1"
    /review.sh ${sha1} || RESULT=1;
    echo "Result: ${RESULT}"
done

echo "Done"

exit $RESULT