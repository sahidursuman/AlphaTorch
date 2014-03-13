module ModelLocking

  LOCKED = Status.get_code('Locked')

  def locked(model)
    model.where(status_code: LOCKED)
  end
  module_function :locked

  def not_locked(model)
    model.where.not(status_code: LOCKED)
  end
  module_function :not_locked

  def lock
    self.status_code = LOCKED
    self.save ? true : false
  end

  def locked?
    self.status_code == LOCKED
  end

end