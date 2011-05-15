require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user1)
  end

  test "User#load_friends should create new friend" do
    json = JSON.parse '[{"name": "user0", "id": "10"}, {"name": "user2", "id": "12"}, {"name": "user3", "id": "13"}, {"name": "user4", "id": "14"}]'
    assert_difference('@user.friends.count') do
      @user.load_friends json
    end
    assert_equal 4, @user.friends.count
  end

  test "User#load_friends should update friend if exits" do
    json = JSON.parse '[{"name": "user2 new name", "id": "12"}, {"name": "user3", "id": "13"}, {"name": "user4", "id": "14"}]'
    @user.load_friends json
    assert_equal 1, @user.friends.where(:name => "user2 new name").count
  end

  test "User#load_friends should remove friendship if not present" do
    json = JSON.parse '[{"name": "user2", "id": "12"}]'
    @user.load_friends json
    assert_equal 1, @user.friends.count
  end

  test "User#credits should return all credits" do
    assert_equal 2, @user.credits.count
  end

  test "User#debits should return all debits" do
    assert_equal 2, @user.credits.count
  end

  test "User#credits_for should return credits for friend" do
    user2 = users(:user2)
    credits = @user.credits_for user2
    assert_equal 1, credits.count
  end

  test "User#debits_for should return credits for friend" do
    user2 = users(:user2)
    debits = @user.debits_for user2
    assert_equal 1, debits.count
  end

  test "User#balance_for should return balance" do
    user2 = users(:user2)
    assert_equal(5, @user.balance_for(user2))
  end

  test "User#balance should return user balance" do
    assert_equal 9.99 + 3.99 - 4.99, @user.balance 
  end

  test "User#debts_for should return debts for friend" do
    friend = users(:user2)
    assert_equal 2, @user.debts_for(friend).count
  end
end
