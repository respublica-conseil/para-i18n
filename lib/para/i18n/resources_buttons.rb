module Para
  module I18n
    module ResourcesButtons
      def translate_button(resource)
        return unless resource.class.translates? && view.can?(:translate, resource)

        path = component.relation_path(resource, :translation, action: :edit)

        options = {
          class: 'btn btn-sm btn-icon-info btn-shadow hint--left',
          data: { 'turbo-frame': '_top' },
          aria: { label: I18n.t('para.i18n.translate') }
        }

        view.link_to(path, **options) do
          content_tag(:i, '', class: 'fa fa-globe')
        end
      end
    end
  end
end
