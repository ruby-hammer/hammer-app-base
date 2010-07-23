module Hammer::Widget::Callback

  # enters scope for callback definition
  # @example onclick on element span executes action block
  #   cb.span('new room').event(:click).action! { a_action }
  def callback
    @callback ||= Callback.new(self)
  end

  alias_method :cb, :callback

  # scope for callback definition
  class Callback
    def initialize(widget)
      @widget, @events = widget, []
    end

    # sores by method element which will be rendered later with callbacks
    # @param args for element
    def method_missing(method, *args, &block)
      raise "invalid state, flush first #{self.inspect}" if @tag
      @tag, @block  = method, block
      @options = args.extract_options!
      @args = args
      self
    end

    # on which event will be callback triggered
    # @param [Symbol] event
    def event(event) # TODO args for events like keypress
      @events << event
      self
    end

    # @yield block action to be executed
    def action(&block)
      raise "invalid state, flush first #{self.inspect}" if @action
      @action = block
      self
    end

    # form callback
    # @param [Object, Fixnum] id a Fixnum or a Object where its #object_id is called to get form's id
    def form(id = @widget.component)
      raise "invalid state, flush first #{self.inspect}" if @form
      id = id.object_id unless id.is_a? Fixnum
      @form = id
      self
    end

    # calls {#action} and {#flush!}
    def action!(&block)
      action(&block)
      flush!
    end

    # calls {#form} and {#flush!}
    def form!(id)
      form(id)
      flush!
    end

    # renders element defined in {#method_missing}, adds callback on {#event}
    def flush!
      hash = {}
      hash[:action] = @widget.__send__ :register_action, &@action if @action
      hash[:form] = @form if @form
      # json = JSON[ hash ]
      json = simple_json(hash)

      @options.merge!( @events.inject({}) {|hash, e| hash[:"data-callback-#{e}"] = json; hash } )
      @widget.__send__ @tag, *@args.push(@options), &@block
      @tag = @action = @form = @block = @options = @args = nil
      @events = []
      nil
    end

    private

    # transforms Hash to JSON
    # @param [Hash] hash one-level hash with primitive types
    def simple_json(hash)
      str = hash.inject('{') {|str, pair| str << pair[0].to_s.inspect << ':' << pair[1].inspect << "," }
      str[-1] = '}'
      str
    end

  end


end