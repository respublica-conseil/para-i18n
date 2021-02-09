module Para
  module I18n
    module FormGeneratorConcern
      extend ActiveSupport::Concern

      included do
        include Para::Admin::BaseHelper
        include Para::Generators::FieldHelpers
        include Para::ModelHelper
        include Para::I18n::Helpers::TranslationsHelper
      end

      private

      def translated_attributes
        translated_model_fields_for(model)
      end

      def nested_relations_attributes
        nested_relations_attributes_for(model)
      end

      def model
        @model ||= class_name.constantize
      end
    end
  end
end
