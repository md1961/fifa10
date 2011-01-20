class AdminController < ApplicationController

  def login
    @page_title = "Football Tracker"

    return unless request.post?

    if user = User.authenticated_user(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to admin_index_path
    else
      flash.now[:notice] = "Invalid username/password combination"
    end
  end

  SESSION_KEYS_TO_DELETE = [
    :user_id, :season_id, :match_filter, :row_filter, :column_filter,
    :last_command_to_filter, :error_explanation, :sort_fields, :is_font_bold,
    :shows_records,
  ]

  def logout
    SESSION_KEYS_TO_DELETE.each do |key|
      session[key] = nil
    end

    flash[:notice] = "Logged out"
    redirect_to login_path
  end

  def index
    user = User.find(session[:user_id])
    redirect_to login_path unless user

    startup_chronicle = Chronicle.find_by_name(Constant.get(:startup_chronicle_name))
    usernames_to_pass = Constant.get(:usernames_to_pass_startup_chronicle)
    if startup_chronicle && ! usernames_to_pass.include?(user.name)
      redirect_to seasons_path(:chronicle_id => startup_chronicle)
    else
      redirect_to chronicles_path
    end
  end
end

