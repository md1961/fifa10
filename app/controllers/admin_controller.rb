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

    session[:season_id] = nil
    session[:match_filter] = nil
    session[:last_command_to_filter] = nil

    flash[:notice] = "Logged out"
    redirect_to :action => 'login'
  end

  def index
    user = User.find(session[:user_id])
    redirect_to :action => 'login' unless user

    startup_chronicle = Chronicle.find_by_name(Constant.get(:startup_chronicle_name))
    usernames_to_pass = Constant.get(:usernames_to_pass_startup_chronicle)
    if startup_chronicle && ! usernames_to_pass.include?(user.name)
      redirect_to :controller => 'seasons', :action => 'list', :chronicle_id => startup_chronicle
    else
      redirect_to :controller => 'chronicles'
    end
  end
end

