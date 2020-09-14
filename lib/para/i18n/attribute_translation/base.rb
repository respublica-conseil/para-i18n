module Para
  module I18n
    module AttributeTranslation
      class Base
        attr_reader :locale, :model, :attribute

        def initialize(locale, model, attribute)
          @locale = locale.to_s
          @model = model
          @attribute = attribute.to_s
        end

        def default_locale?
          @default_locale ||= locale == I18n.default_locale.to_s
        end

        def fallback_locale
          @fallback_locale ||= Para::I18n::Fallbacks.i18n_fallback_for(locale.to_sym)
        end
      end
    end
  end
end
