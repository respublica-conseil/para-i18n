module Para
  module I18n
    module ResourcesTable
      extend ActiveSupport::Concern

      included do
        last_action = default_actions.pop
        default_actions << :translate
        default_actions << last_action
      end
    end
  end
end
