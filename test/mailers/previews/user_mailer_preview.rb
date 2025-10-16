# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def task_created
    UserMailer.with(params).task_created
  end

  def task_updated
    UserMailer.with(params).task_updated
  end

  def task_destroyed
    UserMailer.with(params).task_destroyed
  end

  def reset_password
    UserMailer.with(params).reset_password
  end

  private

  def params
    user = User.first
    task = Task.first
    { user: user, task: task }
  end
end
