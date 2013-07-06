class UsersController < ApplicationController

  def show
  end

  def reset_authentication_token
    current_user.reset_authentication_token!
    redirect_to user_path(current_user)
  end

end