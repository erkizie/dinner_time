require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
Bundler.require(*Rails.groups)

module DinnerTimeApp
  class Application < Rails::Application
    config.load_defaults 7.2
    config.paths.add 'app/services', eager_load: true
    config.paths.add 'app/queries', eager_load: true
    config.paths.add 'app/serializers', eager_load: true
    config.generators.system_tests = nil
  end
end
