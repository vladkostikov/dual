class SendResetPasswordNotificationJob < MailerJob
  def perform(user_id)
    user = User.find_by(id: user_id)
    return if user.blank?

    UserMailer.with(user: user).reset_password.deliver_now
  end
end
