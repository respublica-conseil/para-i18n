module Para
  module Inputs
    class I18nInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        model = object.class

        template.render(
          partial: 'para/inputs/i18n',
          locals: {
            form: @builder,
            resource: object,
            attribute_name: attribute_name,
            locale: locale
          }
        )
      end

      private

      def locale
        if (locale = options[:locale])
          locale
        else
          raise 'Missing `:locale` option passed to :i18n input.'
        end
      end
    end
  end
end
