class AuthController < ApplicationController

  skip_before_filter :check_access_rights
  before_filter :check_if_already_authenticated

  def start_session
    #
  end

  def login
    #
  end

  def logout
    reset_session
    redirect_to '/'
  end

  private

  def check_if_already_authenticated
    if current_user?
      redirect_to :controller => :charts
    end
  end

end
