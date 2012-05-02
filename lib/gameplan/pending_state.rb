class Gameplan
  class PendingState
    attr_reader :name, :desc, :endpoints

    def initialize(app, name, desc)
      @app, @name, @desc, @endpoints = app, name, desc, []
    end

    def compile
    end

    def validate
      add_warning "State #{@name} is pending"
    end

    def add_warning(str)
      @app.add_warning(str)
    end
  end
end