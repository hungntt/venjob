class History < SavedJob
  before_save :history_count

  private

  def history_count
    history_list = self.user.histories.order(updated_at: :desc)
    history_list.last.destroy if history_list.count > 20
  end
end
