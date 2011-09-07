class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :graph

  def authenticate
    redirect_to welcome_url unless current_user
  end

  def current_user
#      @current_user ||= User.where(:name => "Wiesia Biesiad").first
    @current_user ||= (find_user || create_user)
  end

  def graph
    @graph ||= Koala::Facebook::GraphAPI.new(token)
  end

  private
  def rest 
    @rest = Koala::Facebook::RestAPI.new(token)
  end

  def oauth
    @oauth ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::APP_SECRET, root_url)
  end

  def create_user 
    return nil if user_json.nil?
    facebook_id = user_json["uid"]
    json_user = rest.fql_query("select uid, name, pic_square from user where uid=#{user_json["uid"]}").first
    user = User.create :facebook_id => json_user["uid"], :name => json_user["name"], :image => json_user["pic_square"], :is_user => true
    user.load_friends friends_json 
    user.save
    user
  end

  def find_user 
    return nil if user_json.nil?
    user = User.where(:facebook_id => user_json["uid"]).first
    unless user.is_user
      user.is_user = true
      user.save
      user.load_friends friends_json
    end
    user
  end

  def user_json 
    @user_json ||= oauth.get_user_info_from_cookies(cookies)
  end

  def token
    @token ||= user_json["access_token"]
  end

  def friends_json
    rest.fql_query "select uid, name, pic_square from user where uid in (select uid2 from friend where uid1=#{user_json["uid"]})"
  end
end
