FROM webispy/checkpatch

RUN apt-get update && apt-get install -y --no-install-recommends \
		gawk \
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY review.sh /review.sh

ENTRYPOINT ["/entrypoint.sh"]