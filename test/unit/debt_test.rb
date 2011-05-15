require 'test_helper'

class DebtTest < ActiveSupport::TestCase
  test "should have debitor" do
    user = (:user1)
    debt = debts(:from1_to2)
    assert_equal users(:user2), debt.debitor
  end

  test "should have creditor" do
    debt = debts(:from1_to2)
    assert_equal users(:user1), debt.creditor
  end
end
