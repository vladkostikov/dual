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

    user.update(password: password, password_confirmation: password_confirmation)
    user.clear_reset_password_token!
    true
  end

  private

  def token_valid?
    if user.blank? || !user.reset_password_period_valid?
      errors.add(:token, 'is invalid or expired')
    end
  end
end
