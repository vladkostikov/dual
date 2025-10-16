class PasswordResetForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/ }

  def user
    @user ||= User.find_by(email: email)
  end

  def deliver_reset_password_instructions
    return false unless valid? && user

    user.generate_reset_password_token!
    UserMailer.reset_password_email(user).deliver_now
    true
  end
end
