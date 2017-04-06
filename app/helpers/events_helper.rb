module EventsHelper
  def day
    self.created_at.strftime('%-d')
  end
end
