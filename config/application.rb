require File.expand_path('../boot', __FILE__)

require 'rails/all'
#require 'ext/fixnum'
require_relative  '../lib/ext/integer'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pcrm
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.load_defaults 5.1
    config.autoload_paths << Rails.root.join('lib')

#    config.active_record.raise_in_transactional_callbacks = true
#    config.middleware.use "PDFKit::Middleware", :print_media_type => true
#    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #config.active_record.raise_in_transactional_callbacks = true
    #I18n.config.enforce_available_locales = true
    #config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    #config.i18n.enforce_available_locales = true
    #config.i18n.default_locale = :ru

     # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
     # config.i18n.default_locale = :de
     config.tinymce.install = :compile
     config.i18n.enforce_available_locales = true
     config.i18n.available_locales = %i(en ja zh ru)
     config.i18n.default_locale = :ru
     #config.time_zone = 'Moskow'
     #config.active_record.default_timezone = :local
     config.action_cable.disable_request_forgery_protection = false
     config.encoding = "utf-8"
  end
end
