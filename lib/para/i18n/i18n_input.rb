module Para
  module Inputs
    class I18nInput < SimpleForm::Inputs::Base
      delegate :content_tag, to: :template

      def input(wrapper_options = nil)
        model = object.class
        render
      end

      def render
        content_tag(:div, class: 'row') do
          content_tag(:div, class: 'col-md-6') do
            ::I18n.with_locale(::I18n.default_locale) do
              original_content
            end
          end +
          content_tag(:div, class: 'col-md-6') do
            ::I18n.with_locale(locale) do
              @builder.input_field(attribute_name, input_options)
            end
          end
        end
      end

      private

      def locale
        locale = options.fetch(:locale, @builder.target_locale)
        return locale if locale.present?

        raise 'No target locale for the current i18n input. Please provide a `:locale`' \
              'option to the :i18n input or the `para_translations_form_for` method'
      end

      def original_content
        value = template.value_for(object, attribute_name)
        value = value.html_safe if original_options[:html_safe] && value
        value
      end

      def original_options
        @original_options ||= options[:original_html] || {}
      end

      def input_options
        @input_options ||= (options[:input_html] || {}).tap do |hash|
          hash[:class] ||= ''
          hash[:class] += ' form-control'
        end
      end
    end
  end
end
