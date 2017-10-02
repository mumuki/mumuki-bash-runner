require 'mumukit'

Mumukit.runner_name = 'bash'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-bash-worker'
end

require_relative './version_hook'
require_relative './metadata_hook'
require_relative './seek_hook'
