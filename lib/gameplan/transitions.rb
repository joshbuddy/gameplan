class Gameplan
  class Transitions < Array
    def initialize(yielder)
      @yielder = yielder
    end

    def emit
      @yielder << self.dup
    end

    def add(state_name, transition_name)
      begin
        self << [state_name, transition_name]
        yield
      ensure
        pop
      end
    end
  end
end