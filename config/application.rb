require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ActiveRecord::Base.logger.class.include ActiveSupport::LoggerSilence
module Speter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.logger = Ougai::Logger.new(STDOUT)
    config.logger.formatter = Ougai::Formatters::Readable.new
    # config.eager_load_paths << Rails.root.join('lib')
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
