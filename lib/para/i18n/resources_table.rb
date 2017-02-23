module Para
  module I18n
    module ResourcesTable
      extend ActiveSupport::Concern

      included do
        last_action = default_actions.pop
        default_actions << :translate
        default_actions << last_action
      end

      def translate_button(resource)
        return unless resource.class.translates?

        path = component.relation_path(resource, :translation, action: :edit)
        options = { class: 'btn btn-sm btn-icon-info btn-shadow hint--left', :'aria-label' => ::I18n.t('para.i18n.translate') }

        view.link_to(path, options) do
          content_tag(:i, '', class: 'fa fa-globe')
        end
      end
    end
  end
end
