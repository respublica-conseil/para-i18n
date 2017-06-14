require 'i18n'

module FriendlyId
  module I18n
    class << self
      def setup(model_class)
        model_class.friendly_id_config.use :slugged
      end

      def included(model_class)
        model_class.extend(ClassMethods)

        # Support for friendly finds on associations for Rails 4.0.1 and above.
        #
        # Borrowed from FriendlyId::Finders module
        #
        if ::ActiveRecord.const_defined?('AssociationRelation')
          association_relation_delegate_class = model_class.relation_delegate_class(::ActiveRecord::AssociationRelation)
          association_relation_delegate_class.send(:include, ClassMethods)
        end

        if ::ActiveRecord.const_defined?('Relation')
          association_relation_delegate_class = model_class.relation_delegate_class(::ActiveRecord::Relation)
          association_relation_delegate_class.send(:include, ClassMethods)
        end
      end
    end

    def set_friendly_id(text, locale = nil)
      locale = locale.try(:to_sym)

      ::I18n.with_locale(locale || ::I18n.locale) do
        set_slug(normalize_friendly_id(text))
      end
    end

    def should_generate_new_friendly_id?
      translation_for(::I18n.locale)[friendly_id_config.slug_column].blank?
    end

    def set_slug(normalized_slug = nil)
      return unless should_generate_new_friendly_id?

      candidates = FriendlyId::Candidates.new(self, normalized_slug || send(friendly_id_config.base))
      slug = slug_generator.generate(candidates) || resolve_friendly_id_conflict(candidates)
      self.slug = slug
    end

    module ClassMethods
      def exists_by_friendly_id?(id, locale = ::I18n.locale)
        locale = locale.try(:to_sym)

        if (exists = by_friendly_id(id, locale).exists?)
          exists
        elsif (fallback_locale = Para::I18n::Fallbacks.i18n_fallback_for(locale)) &&
          fallback_locale != locale
        then
          exists_by_friendly_id?(id, fallback_locale)
        end
      end

      private

      def first_by_friendly_id(id, locale = ::I18n.locale)
        locale = locale.try(:to_sym)

        if (first = by_friendly_id(id, locale).first)
          first
        elsif (fallback_locale = Para::I18n::Fallbacks.i18n_fallback_for(locale)) &&
          fallback_locale != locale
        then
          first_by_friendly_id(id, fallback_locale)
        end
      end

      def by_friendly_id(id, locale = ::I18n.locale)
        locale = locale.try(:to_sym)

        if locale == ::I18n.default_locale
          where(table_name => { friendly_id_config.query_field => id })
        else
          json_path = "{#{ locale },#{ friendly_id_config.query_field }}"
          where("#{ table_name }._translations#>>'#{ json_path }' = ?", id)
        end
      end
    end
  end
end

