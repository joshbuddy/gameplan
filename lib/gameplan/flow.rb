class Gameplan
  class Flow
    def initialize(plan, name, &blk)
      @plan = plan
      @name = name
      instance_eval(&blk) if blk
    end

    def apps(*apps)
      @apps = apps
    end
    alias_method :app, :apps

    def from(name)
      @from = name
    end

    def to(name)
      @to = name
    end

    def steps(count)
      @step_count = count
    end

    def traverse(app, user)
      Enumerator.new do |yielder|
        @plan.apps.each do |app_name, app|
          initial_state = app.states[@from]
          initial_state.traverse(user, @to, @step_count, Transitions.new(yielder))
        end
      end
    end

    def traversable?(user)
      !traverse(user).empty?
    end
  end
end
