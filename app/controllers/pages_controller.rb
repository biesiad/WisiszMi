class PagesController < ApplicationController
  before_filter :authenticate, :except => [:welcome]

  def welcome
  end

  def home
    @frineds = current_user.frineds
  end
end
