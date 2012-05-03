class Gameplan
  module Describe
    def desc(d)
      description_list << d
    end

    def description
      description_list.join("\n\n")
    end

    def description_list
      @desc ||= []
    end
  end
end