class PasswordResetForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true, format: { with: /\A\S+@.+\.\S+\z/ }

  def user
    @user ||= User.find_by(email: email)
  end

  def deliver_reset_password_instructions
    return false unless valid?
    return false unless user

    ResetPasswordService.new(user).generate_token!
    UserMailer.with(user: user).reset_password.deliver_later
    true
  end
end
