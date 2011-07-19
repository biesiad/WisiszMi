class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :graph

  def authenticate
    redirect_to welcome_url unless current_user
  end

  def current_user
    #@current_user ||= User.first 
    @current_user ||= load_user 
  end

  def graph
    @graph ||= Koala::Facebook::GraphAPI.new(@token)
  end

  private
  def oauth
    @oauth ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::APP_SECRET, root_url)
  end

  def load_user 
    cookie_user = oauth.get_user_info_from_cookies(cookies)
    if cookie_user 
      token = cookie_user["access_token"]
      rest = Koala::Facebook::RestAPI.new token
      facebook_id = cookie_user["uid"]
      @current_user = User.where(:facebook_id => facebook_id).first
      if @current_user.nil?
        user = rest.fql_query("select uid, name, pic_square from user where uid=#{facebook_id}").first
        @current_user = User.create :facebook_id => user["uid"], :name => user["name"], :image => user["pic_square"], :is_user => true
        friends = rest.fql_query "select uid, name, pic_square from user where uid in (select uid2 from friend where uid1=#{facebook_id})"
        @current_user.load_friends friends
      elsif !@current_user.is_user
        puts @current_user.inspect
        puts "NOT User"
        friends = rest.fql_query "select uid, name, pic_square from user where uid in (select uid2 from friend where uid1=#{facebook_id})"
        @current_user.load_friends friends
        puts "friends loaded"
        u = User.find @current_user.id
        u.is_user = true
        u.save
      end
      @current_user
    end 
  end
end
