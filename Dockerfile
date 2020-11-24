FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL

RUN apt-get update && apt-get install -y ca-certificates language-pack-en \
	&& locale-gen $LC_ALL \
	&& dpkg-reconfigure locales \
	&& apt-get install -y \
		curl \
		codespell \
		git \
		jq \
		patch \
		wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ \
	&& chmod +x /usr/bin/checkpatch.pl \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/bionic/patches/0001-checkpatch-add-option-for-excluding-directories.patch -P /tmp/ \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/bionic/patches/0002-ignore_const_struct_warning.patch -P /tmp/ \
	&& cd /usr/bin \
	&& cat /tmp/0001-checkpatch-add-option-for-excluding-directories.patch | patch \
	&& cat /tmp/0002-ignore_const_struct_warning.patch | patch \
	&& rm /tmp/*.patch

CMD ["/bin/bash"]
