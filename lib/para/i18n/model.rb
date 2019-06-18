module Para
  module I18n
    module Model
      extend ActiveSupport::Concern

      included do
        class_attribute :translated_attribute_names
        class_attribute :translatable
      end

      def read_translated_attribute(field, locale = ::I18n.locale)
        return read_plain_or_store_attribute(field) if locale == ::I18n.default_locale && field != :_disabled_for_locale

        if model_translations[locale.to_s]
          if (translation = model_translations[locale.to_s][field.to_s])
            return translation
          end
        end

        # If no translation was returned, try to fallback to the next locale
        if (fallback_locale = Fallbacks.i18n_fallback_for(locale))
          read_translated_attribute(field, fallback_locale)
        end
      end

      def write_translated_attribute field, value, locale = ::I18n.locale
        return write_plain_or_store_attribute(field, value) if locale == ::I18n.default_locale && field != :_disabled_for_locale

        # did not us ||= here to fix first assignation.
        # Did not investigate on why ||= does not work
        model_translations[locale.to_s] = {} unless model_translations[locale.to_s]
        model_translations[locale.to_s][field.to_s] = value
      end

      def model_translations
        unless respond_to?(:_translations)
          raise "The model #{ self.class.name } is not translatable. " +
                "Please run `rails g para:i18n:translate #{ self.model_name.element }` " +
                "generator to create the model's migration."
        end

        self._translations ||= {}
      end

      def translation_for(locale)
        case locale
        when I18n.default_locale then default_locale_translations
        else model_translations[locale.to_s] || {}
        end.with_indifferent_access
      end

      def disabled_for_locale?
        self.class.translates? && _disabled_for_locale
      end

      private

      def read_plain_or_store_attribute(field)
        if plain_column?(field)
          read_attribute(field)
        elsif (store_name = find_stored_column(field))
          read_store_attribute(store_name, field)
        else
          raise ActiveRecord::UnknownAttributeError.new(self, field)
        end
      end

      def write_plain_or_store_attribute(field, value)
        if plain_column?(field)
          write_attribute(field, value)
        elsif (store_name = find_stored_column(field))
          write_store_attribute(store_name, field, value)
        else
          raise ActiveRecord::UnknownAttributeError.new(self, field)
        end
      end

      def plain_column?(field)
        self.class.columns_hash.key?(field.to_s)
      end

      def find_stored_column(field)
        store = self.class.stored_attributes.find do |name, attributes|
          attributes.include?(field.to_sym)
        end

        store.first if store
      end

      def default_locale_translations
        translated_attribute_names.each_with_object({}) do |attribute_name, hash|
          hash[attribute_name] = read_plain_or_store_attribute(attribute_name)
        end
      end

      module ClassMethods
        def translates(*fields)
          self.translated_attribute_names = fields.map(&:to_sym)
          self.translatable = true

          fields.each do |field|
            define_method field do
              read_translated_attribute(field)
            end

            define_method :"#{ field }=" do |value|
              write_translated_attribute(field, value)
            end
          end

          define_method(:_disabled_for_locale) do
            read_translated_attribute(:_disabled_for_locale) == "1"
          end

          define_method(:_disabled_for_locale=) do |value|
            write_translated_attribute(:_disabled_for_locale, value)
          end
        end

        def translates?
          translatable
        end
      end
    end
  end
end
