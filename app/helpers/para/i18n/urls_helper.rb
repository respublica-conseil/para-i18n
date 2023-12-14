module Para
  module I18n
    module UrlsHelper
      def translations_form_locale_path_for(resource, target_locale)
        @component.relation_path(resource, :translation, action: :edit, target_locale:)
      end
    end
  end
end
