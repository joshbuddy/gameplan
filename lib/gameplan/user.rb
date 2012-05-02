class Gameplan
  class User
    attr_reader :type

    def initialize(type, *capabilities)
      @type, @capabilities = type, capabilities
    end
  end
end
