class User < ApplicationRecord
  has_secure_password

  has_many :my_tasks, class_name: 'Task', foreign_key: :author_id
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id

  validates :first_name, :last_name, :email, presence: true
  validates :first_name, :last_name, length: { minimum: 2 }
  validates :email, uniqueness: true, format: { with: /\A\S+@.+\.\S+\z/ }

  def generate_reset_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)

    self.reset_password_sent_at = Time.current
    save!
  end

  def reset_password_period_valid?
    reset_password_sent_at && reset_password_sent_at >= 24.hours.ago
  end

  def clear_reset_password_token!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!
  end
end
