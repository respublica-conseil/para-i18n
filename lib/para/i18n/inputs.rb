require "para/inputs/nested_many_input"
require 'para/i18n/inputs/nested_many_input'

Para::Inputs::NestedManyInput.prepend(Para::I18n::Inputs::NestedManyInput)
