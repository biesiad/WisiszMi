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
      graph = Koala::Facebook::GraphAPI.new(token)
      facebook_id = cookie_user["uid"]
      @current_user = User.where(:facebook_id => facebook_id).first
      if @current_user.nil?
        @current_user = User.create :facebook_id => facebook_id, :name => graph.get_object("me")["name"], :is_user => true
        friends_json = graph.get_connections("me", "friends")
        @current_user.load_friends friends_json
      elsif !@current_user.is_user
        friends_json = graph.get_connections("me", "friends")
        @current_user.load_friends friends_json
        @current_user.is_user = true
        @current_user.save
      end
      @current_user
    end 
  end
end
