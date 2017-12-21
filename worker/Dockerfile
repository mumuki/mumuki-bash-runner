FROM ubuntu
MAINTAINER mumuki
RUN apt-get update && \
    apt-get install git -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/mumuki/

RUN useradd -U mumuki

RUN chmod o-x -R /bin/
RUN chmod o-x -R /sbin/
RUN chmod o-x -R /usr/bin/
RUN chmod o-x -R /usr/sbin/
RUN chmod o+x /usr/bin/
RUN chmod o+x /usr/bin/groups

RUN chmod o+x /bin/
RUN chmod o+x /bin/cp
RUN chmod o+x /bin/mv
RUN chmod o+x /bin/bash
RUN chmod o+x /bin/pwd
RUN chmod o+x /bin/ls
RUN chmod o+x /bin/cat
RUN chmod o+x /bin/touch
RUN chmod o+x /bin/mkdir
RUN chmod o+x /usr/bin/git
RUN chmod o+x /bin/grep

RUN chmod o=rwx /home/mumuki/
USER mumuki
RUN git config --global user.name "mumukibot"
RUN git config --global user.email "bot@mumuki.org"
