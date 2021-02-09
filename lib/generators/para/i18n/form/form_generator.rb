require "generators/para/i18n/base_form_generator"

module Para
  module I18n
    class FormGenerator < Para::Generators::NamedBase
      include Para::I18n::FormGeneratorConcern

      source_root File.expand_path("../templates", __FILE__)

      def generate_form
        template(
          "_translations_form.html.haml",
          "app/views/admin/#{ plural_namespaced_path }/_translations_form.html.haml"
        )
      end
    end
  end
end
