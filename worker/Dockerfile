FROM ubuntu
MAINTAINER mumuki
RUN apt-get update && \
    apt-get install git -y && \
    rm -rf /var/lib/apt/lists/*

COPY runbash /bin/runbash
RUN chmod u+x /bin/runbash
