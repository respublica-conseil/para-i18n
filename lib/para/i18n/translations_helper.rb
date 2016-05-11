module Para
  module I18n
    module TranslationsHelper
      # TODO : Support images & co
      def translated_model_fields_for(model)
        model_field_mappings(model).fields.select do |field|
          model.translated_attribute_names.include?(field.name.to_sym)
        end
      end
    end
  end
end
