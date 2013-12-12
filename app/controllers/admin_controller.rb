#encoding: utf-8

class AdminController < ApplicationController

  skip_before_filter :check_access_rights
  before_filter :check_is_admin

  def index
    #
  end

  private

  def check_is_admin
    unless current_user? && current_user.is_admin?
      redirect_to '/mybets', notice: 'Вы не авторизованы'
    end
  end

end
