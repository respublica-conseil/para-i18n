require 'para/i18n/translations_helper'

module Para
  module I18n
    class FormGenerator < Para::Generators::NamedBase
      include Para::Admin::BaseHelper
      include Para::Generators::FieldHelpers
      include Para::ModelHelper
      include Para::I18n::TranslationsHelper

      source_root File.expand_path("../templates", __FILE__)

      def generate_form
        template(
          "_translations_form.html.haml",
          "app/views/admin/#{ plural_namespaced_path }/_translations_form.html.haml"
        )
      end

      private

      def translated_attributes
        translated_model_fields_for(model)
      end

      def model
        @model ||= Para.const_get(class_name)
      end
    end
  end
end
