module Para
  module Admin
    class TranslationsController < ::Para::Admin::CrudResourcesController
      before_action :load_locales

      def edit
      end

      def update
        if I18n.with_locale(@target_locale) { resource.update(resource_params) }
          flash_message(:success, resource)
          redirect_to after_form_submit_path
        else
          flash_message(:error, resource)
          render 'edit'
        end
      end

      private

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, :resource, class: resource_model
        )

        loader.load_and_authorize_resource
      end

      def load_locales
        @locales = I18n.available_locales - [I18n.default_locale]
        @target_locale = params[:target_locale] || @locales.first
      end

      def resource_params
        params.require(:resource).permit!
      end
    end
  end
end
