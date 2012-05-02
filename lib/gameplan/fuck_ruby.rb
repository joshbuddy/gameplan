GameplanInstance = Gameplan.new

class String
  # sorry ruby, had to do it.

  def app(type, &blk)
    GameplanInstance.app(self, type, &blk)
  end

  def common_state(name, &blk)
    GameplanInstance.last_app.common_state(name, self, &blk)
  end

  def goto(state)
    GameplanInstance.last_app.last_state.endpoint(state, self)
  end

  def state(name, &blk)
    GameplanInstance.last_app.state(name, self, &blk)
  end

  def pending_state(name, &blk)
    GameplanInstance.last_app.pending_state(name, self)
  end
end