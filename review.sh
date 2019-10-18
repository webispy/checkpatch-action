#!/bin/bash

RESULT=`git show --format=email $1 | checkpatch.pl --no-tree -`

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
                else
                    COMMENT="{ \"path\": \"$FILE\", \"line\": \"$LINE\", \"body\": \"$MESSAGE\" }"
                fi
                echo $COMMENT

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
