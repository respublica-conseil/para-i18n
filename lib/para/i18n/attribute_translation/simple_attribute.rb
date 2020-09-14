module Para
  module I18n
    module AttributeTranslation
      class SimpleAttribute < Para::I18n::AttributeTranslation::Base
        def read(resource)
          # Directly read the plain column / store accessor if the current locale is the
          # default one..
          if default_locale? && attribute != "_disabled_for_locale"
            return resource.read_plain_or_store_attribute(attribute)
          end

          translations = resource.model_translations[locale]

          if translations && (translation = translations[attribute])
            translation
          elsif fallback_locale
            # If no translation was returned, try to fallback to the next locale
            self.class.new(fallback_locale, model, attribute).read(resource)
          end
        end

        def write(resource, value)
          if default_locale? && attribute != "_disabled_for_locale"
            return resource.write_plain_or_store_attribute(attribute, value)
          end

          # did not us ||= here to fix first assignation.
          # Did not investigate on why ||= does not work
          resource.model_translations[locale] = {} unless resource.model_translations[locale]
          resource.model_translations[locale][attribute] = value
          resource._translations_will_change!
          value
        end
      end
    end
  end
end
