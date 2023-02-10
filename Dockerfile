FROM webispy/checkpatch@sha256:2f81922a25592cc0512a6b52a8dd69d49cc9e688bb24a3afdb341320ecff8749

COPY entrypoint.sh /entrypoint.sh
COPY review.sh /review.sh

ENTRYPOINT ["/entrypoint.sh"]
