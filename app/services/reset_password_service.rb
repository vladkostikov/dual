class ResetPasswordService
  RESET_PASSWORD_PERIOD = 24.hours

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def generate_token!
    begin
      user.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: user.reset_password_token)

    user.reset_password_sent_at = Time.current
    user.save!
    user.reset_password_token
  end

  def token_valid?
    user.reset_password_sent_at && user.reset_password_sent_at >= RESET_PASSWORD_PERIOD.ago
  end

  def clear_token!
    user.reset_password_token = nil
    user.reset_password_sent_at = nil
    user.save!
  end
end
