module Para
  module Admin
    class TranslationsController < ::Para::Admin::ResourcesController
      include Para::Admin::ResourceControllerConcerns

      before_action :load_and_authorize_crud_resource
      before_action :load_locales
      before_action :add_breadcrumbs

      def edit
      end

      def update
        if ::I18n.with_locale(@target_locale) { resource.update(resource_params) }
          flash_message(:success, resource)
          redirect_to after_form_submit_path
        else
          flash_message(:error, resource)
          render 'edit'
        end
      end

      private

      def load_and_authorize_crud_resource
        options = { class: resource_model }

        options.merge!(
          singleton: true,
          through: :component
        ) unless params.key?(:resource_id)

        loader = self.class.cancan_resource_class.new(self, :resource, options)
        loader.load_and_authorize_resource
      end

      def load_locales
        @locales = ::I18n.available_locales - [::I18n.default_locale]
        @target_locale = params[:target_locale] || @locales.first
      end

      def resource_params
        params.require(:resource).permit!
      end

      def add_breadcrumbs
        add_breadcrumb(resource_title_for(resource)) if resource
        add_breadcrumb(t('para.i18n.translation'))
      end
    end
  end
end
