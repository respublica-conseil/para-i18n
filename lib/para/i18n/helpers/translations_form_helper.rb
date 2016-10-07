module Para
  module I18n
    module Helpers
      module TranslationsFormHelper
        def target_locale_select
          render partial: 'para/admin/translations/target_locale_select',
            locals: { locales: @locales, target_locale: @target_locale }
        end
      end
    end
  end
end
