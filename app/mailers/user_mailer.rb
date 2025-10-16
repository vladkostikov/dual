class UserMailer < ApplicationMailer
  def task_created
    user = params[:user]
    @task = params[:task]

    mail(to: user.email, subject: 'New Task Created')
  end

  def task_updated
    user = params[:user]
    @task = params[:task]

    mail(to: user.email, subject: 'Task Updated')
  end

  def task_destroyed
    user = params[:user]
    @task = params[:task]

    mail(to: user.email, subject: 'Task Destroyed')
  end

  def reset_password_email(user)
    @user = user
    @url  = edit_password_url(token: @user.reset_password_token)

    mail(to: @user.email, subject: 'Reset Your Password')
  end
end
