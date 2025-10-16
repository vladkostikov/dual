require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  test 'task created' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_created

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@kostikov.ru'], email.from
    assert_equal [user.email], email.to
    assert_equal 'New Task Created', email.subject
    assert email.body.to_s.include?("Task ##{task.id} – \"#{task.name}\" has been created successfully")
  end

  test 'task updated' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_updated

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@kostikov.ru'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Updated', email.subject
    assert email.body.to_s.include?("Task ##{task.id} – \"#{task.name}\" has been updated")
  end

  test 'task destroyed' do
    user = create(:user)
    task = create(:task, author: user)
    params = { user: user, task: task }
    email = UserMailer.with(params).task_destroyed

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@kostikov.ru'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Task Destroyed', email.subject
    assert email.body.to_s.include?("Task ##{task.id} – \"#{task.name}\" has been deleted")
  end

  test 'reset password' do
    user = create(:user)
    user.generate_reset_password_token!
    params = { user: user }

    email = UserMailer.with(params).reset_password_email(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@kostikov.ru'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Reset Your Password', email.subject
    assert email.body.to_s.include?(edit_password_url(token: user.reset_password_token))
  end
end
