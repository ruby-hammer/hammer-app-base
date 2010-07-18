module Chat
  class MessageForm < Isy::Component::FormPart

    def initialize(context, message)
      super(context)
      @record = message
    end

    alias_method(:message, :record)

    class Widget < Isy::Component::FormPart::Widget
      def content
        widget Isy::Widget::FormPart::Textarea, :value => :text, :options => 
            { :rows => 2, :cols => 100, :class => %w[ui-widget-content ui-corner-all] }
        a "Send", :click => [ actualize_form, do_action { 
            if message.valid?
              message.time! 
              answer!(message)  
            end
          }]
      end
    end

  end
end