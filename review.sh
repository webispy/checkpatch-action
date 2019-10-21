#!/bin/bash

COMMIT=$1
PRNUM=$2
TOKEN=$3

RESULT=`git show --format=email $1 | checkpatch.pl --no-tree -`
BODY_URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${PRNUM}/comments
CODE_URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${PRNUM}/comments

FOUND=0
MESSAGE=
REVIEW=()

while read -r line
do
    if [[ "$line" =~ ^total: ]]
    then
        break
    fi

    # Need message for file or commit
    if [[ "$FOUND" == "1" ]]
    then
        if [[ "$line" =~ ^\# ]]
        then
            # message for file
            IFS=':' read -r -a list <<< "$line"
            FILE=${list[2]}
            LINE=${list[3]}
        else
            if [[ -z $line ]]
            then
                if [[ -z $FILE ]]
                then
                    COMMENT="{ \"body\": \"$MESSAGE\" }"
                    echo "body comment: $COMMENT"
                    curl -s $BODY_URL -H "Authorization: token ${GITHUB_TOKEN}" \
                        -X POST -d $COMMENT
                else
                    COMMENT="{ \"commit_id\": \"$COMMIT\", \"path\": \"$FILE\", \"line\": \"$LINE\", \"body\": \"$MESSAGE\" }"
                    echo "code comment: $COMMENT"
                    curl -s $CODE_URL -H "Authorization: token ${GITHUB_TOKEN}" \
                        -X POST -d $COMMENT
                fi

                REVIEW+=($COMMENT)
                FOUND=0
                FILE=
                LINE=
            fi
        fi
    fi

    if [[ "$line" =~ ^(WARNING|ERROR) ]]
    then
        MESSAGE=$line
        FOUND=1
        FILE=
        LINE=
    fi

done <<<"$RESULT"
