module Para
  module I18n
    module Fallbacks
      def self.i18n_fallback_for(locale)
        return unless ::I18n.respond_to?(:fallbacks)

        if (fallbacks = ::I18n.fallbacks[locale]) && fallbacks.length > 1
          fallbacks[1]
        else
          ::I18n.default_locale
        end
      end
    end
  end
end
