require 'test_helper'

class ResetPasswordServiceTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @service = ResetPasswordService.new(@user)
  end

  test 'generate_token! sets token and timestamp' do
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at

    token = @service.generate_token!

    assert_equal token, @user.reset_password_token
    assert @user.reset_password_sent_at.present?
  end

  test 'generate_token! generates unique tokens' do
    other_user = create(:user)
    other_service = ResetPasswordService.new(other_user)

    token1 = @service.generate_token!
    token2 = other_service.generate_token!

    assert_not_equal token1, token2
  end

  test 'token_valid? returns true if token is fresh' do
    @service.generate_token!
    assert @service.token_valid?
  end

  test 'token_valid? returns false if token is expired' do
    @service.generate_token!
    @user.update!(reset_password_sent_at: 25.hours.ago)

    assert_not @service.token_valid?
  end

  test 'clear_token! clears token and timestamp' do
    @service.generate_token!
    assert @user.reset_password_token.present?
    assert @user.reset_password_sent_at.present?

    @service.clear_token!
    assert_nil @user.reset_password_token
    assert_nil @user.reset_password_sent_at
  end
end
