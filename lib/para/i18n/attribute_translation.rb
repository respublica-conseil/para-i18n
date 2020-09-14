module Para
  module I18n
    # This module redirects the reading and writing of the translated attributes to the
    # right attribute translation class
    #
    module AttributeTranslation
      def self.read(locale, resource, attribute)
        attribute_translation_class(locale, resource.class, attribute).read(resource)
      end

      def self.write(locale, resource, attribute, value)
        attribute_translation_class(locale, resource.class, attribute).write(resource, value)
      end

      def self.attribute_translation_class(locale, model, attribute)
        attribute_translation_class = if AttributeTranslation::Attachment.matches?(model, attribute)
          AttributeTranslation::Attachment.new(locale, model, attribute)
        else
          AttributeTranslation::SimpleAttribute.new(locale, model, attribute)
        end
      end
    end
  end
end


