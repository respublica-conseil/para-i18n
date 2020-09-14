module Para
  module I18n
    module AttributeTranslation
      class Attachment < Para::I18n::AttributeTranslation::Base
        def read(resource)
          attachment = resource.public_send(reflection_name)

          if default_locale? || attachment.attached? || !fallback_locale
            attachment
          elsif fallback_locale
            self.class.new(fallback_locale, model, attribute).read(resource)
          end
        end

        def write(resource, value)
          resource.public_send(:"#{reflection_name}=", value)
        end

        def self.matches?(model, attribute)
          model.reflections.key?("#{attribute}_attachment") &&
            model.reflections.key?("#{attribute}_blob")
        end

        def self.prepare(model, attribute)
          return unless matches?(model, attribute)

          (I18n.available_locales - [I18n.default_locale]).each do |locale|
            new(locale, model, attribute).prepare_translated_attachment
          end
        end

        def prepare_translated_attachment
          model.alias_method(untranslated_getter_name, attribute)
          model.alias_method(untranslated_setter_name, :"#{attribute}=")
          model.has_one_attached(reflection_name)
        end

        private

        def reflection_name
          @reflection_name ||= if default_locale?
            untranslated_getter_name
          else
            [attribute, locale, "translation"].join("_")
          end
        end

        def untranslated_getter_name
          @untranslated_getter_name ||= :"untranslated_#{attribute}"
        end

        def untranslated_setter_name
          @untranslated_setter_name ||= :"untranslated_#{attribute}="
        end
      end
    end
  end
end
