# frozen_string_literals: true

module Para
  module I18n
    module FormBuilder
      # Thid module provides methods to extend the para's nested form functionality by
      # extending the SimpleForm::FormBuilder.
      #
      module NestedForm
        # Traverses the parent_builder chain until the top of the builder chain returning
        # the top-most form builder which represents the one created through the
        # `form_for` like helper.
        #
        # Note that this could go into the Para::FormBuilder::NestedForm module, but it's
        # not used inside Para, so we keep it here for now.
        #
        def top_level_form_builder
          parent_builder = options[:parent_builder]

          while parent_builder && parent_builder.options[:parent_builder]
            parent_builder = parent_builder.options[:parent_builder]
          end

          parent_builder || self
        end

        # Don't allow nested fields destruction if we're in a translations form as this is
        # the method used by the FormBuilder#remove_association_button method to check
        # whether it's allowed to render the remove button or not.
        #
        def allow_destroy?
          return false if translations_form?

          super
        end

        # Overrides the Para::FormBuilder::NestedForm#fields_partial_name method to render
        # a different nested fields partial when the builder is a translations form
        #
        def nested_fields_partial_name
          translations_form? ? :translations_fields : :fields
        end
      end
    end
  end
end
