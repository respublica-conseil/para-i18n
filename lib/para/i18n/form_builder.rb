require 'para/form_builder'

require 'para/i18n/form_builder/nested_form'
require 'para/i18n/form_builder/translations_form'

# Extend the para extended simple_form form builder to included translations related
# methods.
#
SimpleForm::FormBuilder.prepend(Para::I18n::FormBuilder::NestedForm)
SimpleForm::FormBuilder.prepend(Para::I18n::FormBuilder::TranslationsForm)
