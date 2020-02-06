require 'mumukit'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'bash'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-bash-worker:1.4'
  config.stateful = true
end

module BashRunner
  REQUIRED_COMMANDS = %w(bash sh).freeze
  DEFAULT_ENABLED_COMMANDS = %w(cat cp git grep head ls mkdir mv sed tail touch).freeze
  ALLOWED_COMMANDS = %w(awk cat cp git grep head ln ls mkdir mv rm rmdir sed tac tail touch wc whoami).freeze
end

require_relative './version_hook'
require_relative './metadata_hook'
require_relative './try_hook'
