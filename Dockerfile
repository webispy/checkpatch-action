FROM webispy/checkpatch

COPY entrypoint.sh /entrypoint.sh
COPY review.sh /review.sh

ENTRYPOINT ["/entrypoint.sh"]