module Para
  module I18n
    class Engine < ::Rails::Engine
      initializer 'para.i18n.include_model_extension_into_active_record' do
        ActiveSupport.on_load(:active_record) do
          include Para::I18n::Model
        end
      end

      initializer 'para.i18n.extend_para_routes' do
        ::Para.config.routes.extend_routes_for(:component) do
          resource :translation, only: [:edit, :update], controller: '/para/admin/translations'
        end

        ::Para.config.routes.extend_routes_for(:crud_component) do
          resource :translation, only: [:edit, :update], controller: '/para/admin/translations'
        end

        ::Para.config.routes.extend_routes_for(:form_component) do
          resource :translation, only: [:edit, :update], controller: '/para/admin/translations'
        end
      end

      initializer 'para.i18n.include_view_helpers' do
        ActiveSupport.on_load(:action_view) do
          include Para::I18n::Helpers::TranslationsHelper
          include Para::I18n::Helpers::TranslationsFormHelper
        end
      end

      initializer 'para.i18n.extend_para_resources_table' do
        ActiveSupport.on_load(:action_view) do
          ::Para::Markup::ResourcesTable.send(:include, Para::I18n::ResourcesTable)
          ::Para::Markup::ResourcesButtons.send(:include, Para::I18n::ResourcesButtons)
        end
      end

      initializer 'para.i18n.add_translate_actions' do
        Para.config.add_actions_for('crud/edit', 'form/show') do
          {
            icon: 'globe',
            label: ::I18n.t('para.i18n.translate'),
            url: @component.relation_path(resource, :translation, action: :edit)
          } if resource.class.translates? && can?(:translate, resource)
        end
      end
    end
  end
end
