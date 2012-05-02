class Gameplan
  class Endpoint
    attr_reader :state, :description

    def initialize(app, state, description)
      @app, @state, @description = app, state, description
    end
  end
end
