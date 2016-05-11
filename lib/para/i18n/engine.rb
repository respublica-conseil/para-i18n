module Para
  module I18n
    class Engine < ::Rails::Engine
      initializer 'i18n_admin.include_model_extension_into_active_record' do
        ActiveSupport.on_load(:active_record) do
          include Para::I18n::Model
        end
      end

      initializer 'i18n_admin.extend_para_routes' do
        ::Para.config.routes.extend_routes_for(:crud_component) do
          resource :translation, only: [:edit, :update]
        end
      end

      initializer 'i18n_admin.include_view_helpers' do
        ActiveSupport.on_load(:action_view) do
          include Para::I18n::TranslationsHelper
        end
      end

      initializer 'i18n_admin.extend_para_resources_table' do
        ActiveSupport.on_load(:action_view) do
          ::Para::Markup::ResourcesTable.send(:include, Para::I18n::ResourcesTable)
        end
      end
    end
  end
end
