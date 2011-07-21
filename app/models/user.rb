class User < ActiveRecord::Base
  validates_uniqueness_of :facebook_id
  validates_presence_of :facebook_id
  validates_presence_of :name

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :credits, :class_name => "Debt", :foreign_key => "user_from_id"
  has_many :debits, :class_name => "Debt", :foreign_key => "user_to_id"
  
  def friends_sorted
    @friends_sorted ||= friends.joins('left outer join debts on debts.user_from_id = users.id or debts.user_to_id = users.id').select('users.*, count(debts.id)').group('users.id').order('count(debts.id) desc, users.name')
  end

  def debts
    @debts ||= Debt.where("user_from_id = ? or user_to_id = ?", self.id, self.id)
  end

  def debts_for friend
    debts.select { |d| d.user_from_id == friend.id || d.user_to_id == friend.id }
  end

  def credits_for friend
    debts.select { |d| d.user_to_id == friend.id }
  end

  def debits_for friend
    debts.select { |d| d.user_from_id == friend.id }
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
      friend = User.where(:facebook_id => f["uid"].to_s).first
      if friend.nil?
        friend = friends.create! :facebook_id => f["uid"], :name => f["name"], :image => f["pic_square"]
      elsif !friends.include? friend
        friends << friend
      end 
      friend_ids << friend.id
    end
    friendships.where("friend_id not in (?)", friend_ids).destroy_all
  end

  def self.load_images
    oauth = Koala::Facebook::OAuth.new Facebook::APP_ID, Facebook::APP_SECRET
    rest = Koala::Facebook::RestAPI.new oauth.get_app_access_token
    ids = User.all.map { |u| u.facebook_id }
    users = rest.fql_query "select uid, pic_square from user where uid in (#{ids.to_s[1..-2]})"
    users.each do |u|
      user = User.where(:facebook_id => u["uid"].to_s).first
      user.image = u["pic_square"]
      user.save!
    end
  end
end

