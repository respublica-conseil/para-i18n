module Para
  module I18n
    module Fallbacks
      mattr_accessor :_disable_fallbacks

      def self.without_i18n_fallbacks(&block)
        self._disable_fallbacks = true
        block.call
      ensure
        self._disable_fallbacks = false
      end

      def self.i18n_fallback_for(locale)
        return if _disable_fallbacks || !::I18n.respond_to?(:fallbacks)

        if (fallbacks = ::I18n.fallbacks[locale]) && fallbacks.length > 1
          fallbacks[1]
        elsif locale != ::I18n.default_locale
          ::I18n.default_locale
        end
      end
    end
  end
end
