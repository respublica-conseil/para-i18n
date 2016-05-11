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
        return unless resource.class.translatable?

        path = component.relation_path(resource, :translation, action: :edit)
        options = { class: 'btn btn-info' }

        view.link_to(path, options) do
          content_tag(:i, '', class: 'fa fa-globe')
        end
      end
    end
  end
end
