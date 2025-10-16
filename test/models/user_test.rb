require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'create' do
    user = create(:user)
    assert user.persisted?
  end

  test 'email format validation' do
    user = build(:user, email: '1@1')
    assert_not user.valid?
    assert_includes user.errors[:email], 'is invalid'
  end

  test 'generate_reset_password_token! sets token and timestamp' do
    user = create(:user)
    assert_nil user.reset_password_token
    assert_nil user.reset_password_sent_at

    user.generate_reset_password_token!

    assert user.reset_password_token.present?
    assert user.reset_password_sent_at.present?
  end

  test 'generate_reset_password_token! generates unique tokens' do
    user1 = create(:user)
    user2 = create(:user)

    user1.generate_reset_password_token!
    user2.generate_reset_password_token!

    assert_not_equal user1.reset_password_token, user2.reset_password_token
  end

  test 'reset_password_period_valid? returns true if token is fresh' do
    user = create(:user)
    user.generate_reset_password_token!

    assert user.reset_password_period_valid?
  end

  test 'reset_password_period_valid? returns false if token is expired' do
    user = create(:user)
    user.generate_reset_password_token!
    user.update!(reset_password_sent_at: 25.hours.ago)

    assert_not user.reset_password_period_valid?
  end

  test 'clear_reset_password_token! clears token and timestamp' do
    user = create(:user)
    user.generate_reset_password_token!
    assert user.reset_password_token.present?
    assert user.reset_password_sent_at.present?

    user.clear_reset_password_token!
    assert_nil user.reset_password_token
    assert_nil user.reset_password_sent_at
  end
end
