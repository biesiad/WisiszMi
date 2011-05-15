class PagesController < ApplicationController
  before_filter :authenticate, :except => [:welcome]

  def welcome
  end

  def home
    @friends = current_user.friends
  end
end
