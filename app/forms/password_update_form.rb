class PasswordUpdateForm
  include ActiveModel::Model

  attr_accessor :token, :password, :password_confirmation

  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true

  validate :token_valid?

  def user
    @user ||= User.find_by(reset_password_token: token)
  end

  def save
    return false unless valid?

    user.update(password: password)
    ResetPasswordService.new(user).clear_token!
    true
  end

  private

  def token_valid?
    if user.blank? || !ResetPasswordService.new(user).token_valid?
      errors.add(:token, :invalid_or_expired)
    end
  end
end
