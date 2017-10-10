require 'mumukit'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'bash'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-bash-worker'
  config.stateful = true
end

require_relative './version_hook'
require_relative './metadata_hook'
require_relative './try_hook'
require_relative './checker'