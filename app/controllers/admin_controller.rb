class AdminController < ApplicationController

  def login
    @page_title = "Football Tracker"

    return unless request.post?

    if user = User.authenticated_user(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to :action => 'index'
    else
      flash.now[:notice] = "Invalid username/password combination"
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to :action => 'login'
  end

  def index
    redirect_to :controller => 'chronicles'
  end
end

