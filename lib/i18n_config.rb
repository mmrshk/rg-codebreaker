# frozen_string_literal: true

I18n.load_path << Dir[File.expand_path('lib/locales/') + '/*.yml']
I18n.config.available_locales = :en
