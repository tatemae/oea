class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    redirect_to user_assessments_path(current_user)
  end

  def reset_authentication_token
    current_user.reset_authentication_token!
    redirect_to new_assessment_path
  end

end
