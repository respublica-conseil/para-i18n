module Para
  module I18n
    module Inputs
      module NestedManyInput
        def input(_wrapper_options = nil)
          # Disable the add button and orderable features of the input.
          # Note : The remove button disabling is done by the
          # Para::I18n::FormBuilder::TranslationsForm extension
          if within_translations_form?
            options[:add_button] = false
            options[:orderable] = false
          end

          super
        end
        private

        def within_translations_form?
          @builder.translations_form?
        end

        # Extend remote partial params with the :_translations_form key if we're in the
        # context of a translations form builder.
        #
        def remote_partial_params
          super.tap do |remote_partial_params|
            if within_translations_form?
              remote_partial_params.deep_merge!(
                builder_options: {
                  Para::I18n::FormBuilder::TranslationsForm::TRANSLATIONS_FORM_PARAM_KEY => true,
                  locale: @builder.target_locale
                }
              )
            end
          end
        end
      end
    end
  end
end

