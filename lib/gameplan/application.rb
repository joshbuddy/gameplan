class Gameplan
  class Application
    include Describe

    attr_reader :states, :name, :pretty_name, :plan, :last_state, :common_states

    def initialize(plan, pretty_name, name, &blk)
      @plan, @pretty_name, @name, @states, @common_states, @blk = plan, pretty_name, name, {}, {}, blk
    end

    def compile
      instance_eval(&@blk)
    end

    def for_user(*capabilities)
      @capabilities = capabilities
    end

    def pending_state(name, desc, &blk)
      raise "#{name} already exists" if @states[name]
      @last_state = @states[name] = PendingState.new(self, name, desc)
      @last_state.compile
      @last_state
    end

    def state(name, desc, &blk)
      raise "#{name} already exists" if @states[name]
      @last_state = @states[name] = State.new(self, name, desc, &blk)
      @last_state.compile
      @last_state
    end

    def common_state(name, desc, &blk)
      raise "#{name} already exists" if @common_states[name]
      @last_state = @common_states[name] = CommonState.new(self, name, desc, &blk)
      @last_state.compile
      @last_state
    end

    def validate
      add_error "For application #{name}, there are no states" if @states.empty?
      @states.values.each { |state| state.validate }
    end

    def add_error(str)
      @plan.add_error(str)
    end

    def add_warning(str)
      @plan.add_warning(str)
    end
  end
end