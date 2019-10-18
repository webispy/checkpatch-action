FROM nugulinux/devenv:bionic

LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="purple"
LABEL "com.github.actions.name"="Helloworld Code Review"
LABEL "com.github.actions.description"="This will run Helloworld on PRs"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]