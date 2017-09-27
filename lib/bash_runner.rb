require 'mumukit'

Mumukit.runner_name = 'bash'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-bash-worker'
end

require_relative './version_hook'
require_relative './metadata_hook'
require_relative './test_hook'
require_relative './query_hook'
