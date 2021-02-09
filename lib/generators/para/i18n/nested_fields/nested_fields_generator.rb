require "generators/para/i18n/base_form_generator"

module Para
  module I18n
    class NestedFieldsGenerator < Para::Generators::NamedBase
      include Para::I18n::FormGeneratorConcern

      source_root File.expand_path("../templates", __FILE__)

      def generate_nested_fields
        template(
          "_translations_fields.html.haml",
          "app/views/admin/#{ plural_namespaced_path }/_translations_fields.html.haml"
        )
      end
    end
  end
end
