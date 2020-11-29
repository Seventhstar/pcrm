require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pcrm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.app_generators.scaffold_controller :responders_controller
    config.load_defaults 5.1

    config.autoload_paths << Rails.root.join('lib')
    #config.autoload_paths +=%W(#{config.root}/app/jobs)
    config.active_job.queue_adapter = :sidekiq


    config.tinymce.install = :compile
    config.i18n.enforce_available_locales = true
    config.i18n.available_locales = %i(en ru)
    config.i18n.default_locale = :ru
    #config.time_zone = 'Moskow'
    #config.active_record.default_timezone = :local
    config.action_cable.disable_request_forgery_protection = false
    config.encoding = "utf-8"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
