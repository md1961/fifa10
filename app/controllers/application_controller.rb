class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize, :except => :login

  def sgn(n)
    return 0 if n == 0
    return n / n.abs
  end

  def log_debug(msg)
    logger.debug "[DEBUG] #{msg}"
  end


  def get_season_id(params={})
    season_id = (params[:season_id] || session[:season_id]).to_i
    if season_id.nil? || season_id <= 0
      raise "No 'season_id' in params nor session (#{session.inspect})"
    end
    session[:season_id] = season_id
    return season_id
  end

  def team_name_and_season_years
    season = Season.find(session[:season_id])
    team = season.team
    return "#{team.name} #{season.years}"
  end

  def team_abbr
    season = Season.find(session[:season_id])
    team = season.team
    return (team.abbr || team.name).downcase
  end

  protected

    def authorize
      unless User.find_by_id(session[:user_id])
        flash[:notice] = "Please log in"
        redirect_to login_path
      end
    end
end
