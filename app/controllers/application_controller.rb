# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def sgn(n)
    return 0 if n == 0
    return n / n.abs
  end

  def log_debug(msg)
    logger.debug "[DEBUG] #{msg}"
  end

  def team_name_and_season_years
    season = Season.find(session[:season_id])
    team = season.team
    return "#{team.name} #{season.years}"
  end
end
