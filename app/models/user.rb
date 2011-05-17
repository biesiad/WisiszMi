class User < ActiveRecord::Base
  validates_uniqueness_of :facebook_id
  validates_presence_of :facebook_id
  validates_presence_of :name

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :credits, :class_name => "Debt", :foreign_key => "user_from_id"
  has_many :debits, :class_name => "Debt", :foreign_key => "user_to_id"
   
  def debts_for friend
    users = [self.id, friend.id]
    Debt.where(:user_from_id => users, :user_to_id => users)
  end

  def credits_for friend
    self.credits.where :user_to_id => friend.id
  end

  def debits_for friend
    self.debits.where :user_from_id => friend.id
  end

  def balance_for friend
    credits_sum = self.credits_for(friend).inject(0) { |sum, c| sum + c.value }
    debits_sum = self.debits_for(friend).inject(0) { |sum, d| sum + d.value }
    credits_sum - debits_sum
  end

  def balance
    credits_sum = self.credits.inject(0) { |sum, c| sum + c.value }
    debits_sum = self.debits.inject(0) { |sum, d| sum + d.value }
    credits_sum - debits_sum
  end

  def load_friends friends_json
    friend_ids = []
    friends_json.each do |f|
      friend = User.where(:facebook_id => f["id"]).first
      if friend.nil? && f["id"] != self.facebook_id
        friend = friends.create! :facebook_id => f["id"], :name => f["name"]
      else
        friends << friend
      end 
      friend_ids << friend.id
    end
    friendships.where("friend_id not in (?)", friend_ids).destroy_all
  end
end
