class DeleteOldDismissalsJob < ApplicationJob
  queue_as :default

  def perform
    Dismissal.where("updated_at < (now() - interval '28 days')").delete_all
  end
end
