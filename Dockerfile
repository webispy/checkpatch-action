FROM webispy/checkpatch@sha256:e84b5049be1410395ecca4547e14b1d209fb9f3327383bef83b25aeb666a8304

COPY entrypoint.sh /entrypoint.sh
COPY review.sh /review.sh

ENTRYPOINT ["/entrypoint.sh"]
