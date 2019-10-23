#!/bin/bash

# To debug the current script, please uncomment the following 'set -x' line
#set -x

# Argument
COMMIT=$1

# Get PR number
PR=${GITHUB_REF#"refs/pull/"}
PRNUM=${PR%"/merge"}

# Generate email style commit message
PATCHMAIL=$(git show --format=email $1 | checkpatch.pl --no-tree -)

# Github REST API endpoints
BODY_URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${PRNUM}/comments
CODE_URL=https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${PRNUM}/comments

# Internal state variables
RESULT=0
FOUND=0
MESSAGE=

# Write message to specific file and line
function post_code_message()
{
    echo "POST to ${CODE_URL} with ${MESSAGE}"
    curl ${CODE_URL} -s \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST --data "$(cat <<EOF
{
    "commit_id": "$COMMIT",
    "path": "${FILE}",
    "position": ${LINE},
    "body": "${MESSAGE}"
}
EOF
)"
}

# Write message to pull-request comment
function post_comment_message()
{
    echo "POST to ${BODY_URL} with ${MESSAGE}"
    curl ${BODY_URL} -s \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST --data "$(cat <<EOF
{
    "body": ":warning: ${COMMIT} - ${MESSAGE}"
}
EOF
)"
}

#
# checkpatch.pl result format
# ---------------------------
#
# Template:
# ---------
#
# [WARNING/ERROR]: [message for code line]
# #[id]: FILE: [filename]:[line-number]
# +[code]
# [empty line]
#
# [WARNING/ERROR]: [message for commit itself]
#
# total: [n] erros, [n] warnings, [n] lines checked
#
# example:
# --------
#
# ERROR: xxxx
# #15: FILE: a.c:3:
# +int main() {
#
# ERROR: Missing Signed-off-by: line(s)
#
# total: ...
#

while read -r row
do
    # End of checkpatch.pl message
    if [[ "$row" =~ ^total: ]]; then
        echo -e "\e[1m$row\e[0m"
        break
    fi

    # Additional parsing is needed
    if [[ "$FOUND" == "1" ]]; then

        # The row is started with "#"
        if [[ "$row" =~ ^\# ]]; then
            # Split the string using ':' seperator
            IFS=':' read -r -a list <<< "$row"

            # Get file-name after removing spaces.
            FILE=$(echo ${list[2]} | xargs)

            # Get line-number
            LINE=${list[3]}
        else
            # An empty line means the paragraph is over.
            if [[ -z $row ]]; then
                if [[ ! -z "$GITHUB_TOKEN" ]]; then
                    echo "Post comment to Github"
                    if [[ -z $FILE ]]; then
                        post_comment_message
                    else
                        post_code_message
                    fi
                else
                    # Output empty line
                    echo
                fi

                # Code review found a problem.
                RESULT=1

                FOUND=0
                FILE=
                LINE=
            fi
        fi
    fi

    # Found warning or error paragraph
    if [[ "$row" =~ ^(WARNING|ERROR) ]]; then
        MESSAGE=$row
        FOUND=1
        FILE=
        LINE=

        echo -e "\e[1;31m$row\e[0m"
    else
        echo $row
    fi

done <<<"$PATCHMAIL"

if [[ "$RESULT" == "0" ]]; then
    echo -e "\e[1;32m>> Success\e[0m"
else
    echo -e "\e[1;31m>> Failure\e[0m"
fi

exit $RESULT