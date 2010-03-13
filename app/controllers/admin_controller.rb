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

  SESSION_KEYS_TO_DELETE = [
    :user_id, :season_id, :match_filter, :row_filter, :column_filter,
    :last_command_to_filter, :error_explanation, :sort_fields, :is_font_bold
  ]

  def logout
    SESSION_KEYS_TO_DELETE.each do |key|
      session[key] = nil
    end

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

