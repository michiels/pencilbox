require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Pencilbox
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/extras)

    config.assets.precompile += %w( fontawesome-webfont.ttf fontawesome-webfont.woff )

    config.after_initialize do
      ActionView::Base.sanitized_allowed_tags << 'iframe'
    end
  end
end
