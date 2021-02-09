module Para
  module I18n
    module Helpers
      module TranslationsHelper
        # TODO : Support images & co
        def translated_model_fields_for(model)
          model_field_mappings(model).fields.select do |field|
            model.translated_attribute_names &&
              model.translated_attribute_names.include?(field.name.to_sym)
          end
        end

        def nested_relations_attributes_for(model)
          model_field_mappings(model).fields.select do |field|
            next unless field.field_type.in?(["nested_one", "nested_many"])

            # This returns nil if the target model is not translated
            model.reflect_on_association(field.name).klass.translatable?
          end
        end
      end
    end
  end
end
