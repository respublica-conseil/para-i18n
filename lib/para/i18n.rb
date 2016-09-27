require 'para'

require 'para/i18n/version'

require 'para/i18n/fallbacks'

require 'para/i18n/model'
require 'para/i18n/resources_table'
require 'para/i18n/translations_helper'

require 'para/i18n/friendly_id'

require 'para/i18n/i18n_input'

require 'para/i18n/engine'

module Para
  module I18n
    # Your code goes here...
    def self.method_missing(method, *args, &block)
      ::I18n.send(method, *args, &block)
    end
  end
end
