# frozen_string_literals: true

module Para
  module I18n
    module FormBuilder
      # Thid module extends the Para overriden SimpleForm::FormBuilder to include some
      # trnaslations form related methods and overrides, allowing a simple use of
      # translations forms with the para-i18n gem.
      #
      module TranslationsForm
        TRANSLATIONS_FORM_PARAM_KEY = :_translations_form

        # Allows storing a gobal reference to the target locale of the translations form,
        # which allows input objects to fetch it directly, without having to provide
        # manually the :locale parameter for each input
        #
        # Example :
        #
        #   = para_translations_form_for(resource, locale: @target_Locale) do |form|
        #     =  form.input :title, as: :i18n # No need to pass `:locale` option here.
        #
        def target_locale
          top_level_form_builder.options.with_indifferent_access[:locale]
        end

        # Allows checking if the current form builder is a translations form, depending
        # on the passed TRANSLATIONS_FORM_PARAM_KEY option. This is automatically passed
        # to the form builder when using the `para_translations_form_for` helper.
        #
        # Example :
        #
        #   para_translations_form_for(resource)
        #   # OR
        #   para_form_for(resource, _translations_form: true)
        #
        def translations_form?
          !!top_level_form_builder.options.with_indifferent_access[TRANSLATIONS_FORM_PARAM_KEY]
        end
      end
    end
  end
end
