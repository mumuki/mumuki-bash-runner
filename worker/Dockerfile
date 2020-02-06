FROM ubuntu
MAINTAINER mumuki
RUN apt-get update && \
    apt-get install git -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/mumuki/

RUN useradd -U mumuki

RUN git config --system user.name "mumukibot"
RUN git config --system user.email "bot@mumuki.org"

RUN chmod o-x -R /bin/
RUN chmod o-x -R /sbin/
RUN chmod o-x -R /usr/bin/
RUN chmod o-x -R /usr/sbin/
RUN chmod o+x /usr/bin/
RUN chmod o+x /usr/bin/groups
RUN chmod o+x /bin/

RUN chmod o=rwx /home/mumuki/

COPY worker/runbash /bin/runbash
