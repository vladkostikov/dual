require 'test_helper'

class Web::PasswordsControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'form input[name="password_reset_form[email]"]'
  end

  test 'should post create and send reset instructions if user exists' do
    user = create(:user)
    attrs = { email: user.email }

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :create, params: { password_reset_form: attrs }
    end

    assert_response :redirect
    assert_redirected_to new_password_path
    assert_equal 'If your email exists, you will receive a password reset link.', flash[:notice]
  end

  test 'should post create even if user does not exist' do
    attrs = { email: 'nonexistent@example.com' }

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post :create, params: { password_reset_form: attrs }
    end

    assert_response :redirect
    assert_redirected_to new_password_path
    assert_equal 'If your email exists, you will receive a password reset link.', flash[:notice]
  end

  test 'should get edit' do
    user = create(:user)
    token = ResetPasswordService.new(user).generate_token!

    get :edit, params: { token: token }

    assert_response :success
    assert_select 'form input[name="password_update_form[token]"][type="hidden"][value=?]', user.reset_password_token
  end

  test 'should patch update and change password if valid' do
    user = create(:user)
    ResetPasswordService.new(user).generate_token!
    new_password = generate(:password)
    attrs = {
      token: user.reset_password_token,
      password: new_password,
      password_confirmation: new_password,
    }

    patch :update, params: { password_update_form: attrs }
    assert_response :redirect
    assert_redirected_to new_session_path
    assert_equal 'Password has been successfully updated. Please log in.', flash[:notice]

    user.reload
    assert user.authenticate(new_password)
  end

  test 'should render edit if password update invalid' do
    user = create(:user)
    ResetPasswordService.new(user).generate_token!
    attrs = {
      token: user.reset_password_token,
      password: generate(:password),
      password_confirmation: generate(:password),
    }

    patch :update, params: { password_update_form: attrs }
    assert_response :success
    assert_select 'form input[name="password_update_form[token]"][type="hidden"][value=?]', user.reset_password_token
  end
end
