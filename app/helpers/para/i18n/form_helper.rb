module Para
  module I18n
    module FormHelper
      def para_translations_form_for(resource, options = {}, &block)
        extended_options = options.reverse_merge(
          Para::I18n::FormBuilder::TranslationsForm::TRANSLATIONS_FORM_PARAM_KEY => true
        )

        para_form_for(resource, extended_options, &block)
      end
    end
  end
end
