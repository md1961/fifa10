class AdminController < ApplicationController

  def login
    return unless request.post?
    user = User.authenticated_user(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to :action => 'index'
    else
      flash.now[:notice] = "Invalid username/password combination"
    end
  end

  def logout
  end

  def index
  end

end
