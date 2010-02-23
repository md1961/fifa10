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
    startup_chronicle = Chronicle.find_by_name(Constant.get(:startup_chronicle_name))
    if startup_chronicle
      redirect_to :controller => 'seasons', :action => 'list', :chronicle_id => startup_chronicle
    else
      redirect_to :controller => 'chronicles'
    end
  end
end

