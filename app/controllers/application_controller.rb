class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_access_rights

  def current_user?
    not current_user.nil?
  end

  def current_user
    User.find(session[:current_user]) if session[:current_user]
  end

  def current_user=(user)
    session[:current_user] = user.id
  end

  helper_method :current_user
  helper_method :current_user=

  private

  def check_access_rights
    redirect_to :controller => :auth, :action => :login unless current_user?
  end

end
