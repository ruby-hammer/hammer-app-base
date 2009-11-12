module Isy
  module Contexts

    class Context
      attr_reader :id, :layout, :root_component

      # id, layout class, root_component class
      def initialize(id, layout_class, root_component_class)
        @id = id
        @layout = layout_class.new(@root_component = root_component_class.new)
        @root_component.app_context = self
        @actions = {}
      end

      def to_s
        @layout.to_s
      end

      def register_action(component, &block)
        uuid = UUID.generate(:compact)
        @actions[uuid] = Action.new(uuid, component, block)
        return uuid
      end

      def run_action(id)
        @actions[id] && begin
          @actions[id].call
        end
        @actions = {}
      end

    end
  end
end