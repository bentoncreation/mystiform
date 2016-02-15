module SimpleForm
  module Components
    module LabelNecessity
      module ClassMethods #:nodoc:
        def translate_optional_html
          i18n_cache :translate_optional_html do
            I18n.t(:"simple_form.optional.html", default:
              %[<abbr title="#{translate_optional_text}">#{translate_optional_mark}</abbr>]
            )
          end
        end

        def translate_optional_text
          I18n.t(:"simple_form.optional.text", default: 'optional')
        end

        def translate_optional_mark
          I18n.t(:"simple_form.optional.mark", default: '*')
        end
      end

      protected

      def required_label_text #:nodoc:
        required_field? ? self.class.translate_required_html.dup : self.class.translate_optional_html.dup
      end
    end
  end
end
