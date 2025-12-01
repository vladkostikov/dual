class SendTaskDestroyNotificationJob < MailerJob
  def perform(author_id, task_id, task_name)
    author = User.find_by(id: author_id)
    return if author.blank?

    UserMailer.with(user: author, task_id: task_id, task_name: task_name).task_destroyed.deliver_now
  end
end
