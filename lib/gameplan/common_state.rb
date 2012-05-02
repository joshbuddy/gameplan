class Gameplan
  class CommonState
    include Describe

    attr_reader :endpoints

    def initialize(app, name, pretty_name, &blk)
      @app = app
      @name = name
      @pretty_name = pretty_name
      @endpoints = []
      @blk = blk
    end

    def compile
      instance_eval(&@blk)
    end

    def endpoint(state, desc)
      @endpoints << Endpoint.new(@app, state, desc)
    end

    def traverse(user, target_state, count, transitions)
      return if count.zero?
      transitions.emit if @name == target_state
      @endpoints.each do |endpoint|
        transitions.add(@name, endpoint.change_name) do
          @app.states[endpoint.state_name].traverse(user, target_state, count - 1, transitions)
        end
      end
    end

    def validate
      add_error "State #{@name} has no endpoints" if @endpoints.empty?
    end

    def add_error(str)
      @app.add_error(str)
    end
  end
end
