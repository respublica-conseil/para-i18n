module Para
  module I18n
    module Model
      extend ActiveSupport::Concern

      included do
        class_attribute :translated_attribute_names
        class_attribute :translatable

        # Fetch all records of the current model that are not disabled for the provided
        # locale, which also includes models that are not translatable and records of 
        # translatable models that are not translated for the current locale.
        #
        scope :enabled_for_locale, ->(locale = I18n.locale) {
          # Models that are not translatable don't have the `_translations` column, so we
          # avoid any query for them.
          next all unless translates?

          with_disabled_for_locale_state(disabled: false, locale: locale)
        }

        # Fetch all records of the current model that are explicitly disabled for the 
        # provided locale.
        #
        scope :disabled_for_locale, ->(locale = I18n.locale) {
          # Models that are not translatable don't have the `_translations` column, so we
          # avoid any query for them.
          next none unless translates?

          with_disabled_for_locale_state(disabled: true, locale: locale)
        }
      end

      def read_translated_attribute(field, locale = ::I18n.locale)
        Para::I18n::AttributeTranslation.read(locale, self, field)
      end

      def write_translated_attribute(field, value, locale = ::I18n.locale)
        Para::I18n::AttributeTranslation.write(locale, self, field, value)
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
        case locale.to_sym
        when I18n.default_locale then default_locale_translations
        else model_translations[locale.to_s] || {}
        end.with_indifferent_access
      end

      def disabled_for_locale?
        self.class.translates? && _disabled_for_locale
      end

      # This method allows reading an attribute from the ActiveRecord table, whether it's
      # a plain column of the table, or a field of a store (hash, json etc.) of the table,
      # accessed through the ActiveRecord.store_accessor interface.
      #
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

      private

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
            prepare_attribute_translation(field)
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

        # This methods is used by both the enabled_for_locale and disabled_for_locale 
        # scopes to filter the records based on the _disabled_for_locale attribute stored
        # in the translations JSONB column for the provided locale.
        def with_disabled_for_locale_state(disabled:, locale: I18n.locale)
          predicate = disabled ? 'IN' : 'NOT IN'

          where(<<-SQL.squish, locale, %w[1 t true])
            COALESCE(#{table_name}._translations->?->>'_disabled_for_locale', '0')
            #{predicate} (?)
          SQL
        end

        private

        def prepare_attribute_translation(attribute)
          # Let the Para::I18n::AttributeTranslation::Attachment module handle
          # ActiveStorage attachment fields translation preparation.
          Para::I18n::AttributeTranslation::Attachment.prepare(self, attribute)

          define_method(attribute) do
            read_translated_attribute(attribute)
          end

          define_method(:"#{attribute}=") do |value|
            write_translated_attribute(attribute, value)
          end
        end
      end
    end
  end
end
