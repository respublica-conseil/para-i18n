module Para
  module I18n
    module ResourcesButtons
      def translate_button(resource)
        return unless resource.class.translates?

        path = component.relation_path(resource, :translation, action: :edit)
        options = { class: 'btn btn-info' }

        view.link_to(path, options) do
          content_tag(:i, '', class: 'fa fa-globe')
        end
      end
    end
  end
end
