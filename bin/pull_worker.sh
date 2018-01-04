#!/bin/bash

TAG=$(grep -e 'mumuki/mumuki-bash-worker:[0-9]*\.[0-9]*' ./lib/bash_runner.rb -o | tail -n 1)

echo "Pulling $TAG..."
docker pull $TAG
