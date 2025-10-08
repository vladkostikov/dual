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
end
