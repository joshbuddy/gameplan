class Gameplan
  module Validation
    def add_warning(msg)
      warnings << msg
    end

    def add_error(msg)
      errors << msg
    end

    def errors
      @errors ||= []
    end

    def warnings
      @warnings ||= []
    end

    def reset_validation!
      errors.clear
      warnings.clear
    end

    def valid?
      errors.empty? && warnings.empty?
    end
  end
end