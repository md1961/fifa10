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

  def players_of_team(includes_on_loan=true, for_lineup=false)
    season_id = session[:season_id]
    raise "no 'season_id' in session (#{session.inspect})" unless season_id
    players = Player.list(season_id, true, for_lineup)

    copy_to_lineup(players) unless for_lineup

    players.reject! { |player| player.on_loan?(season_id) } unless includes_on_loan

    return players
  end

  def copy_to_lineup(players)
    season_id = get_season_id(params)

    map_lineup = Hash.new
    players.each do |player|
      map_lineup[player.id] = player.order_number(season_id)
    end

    SimpleDB.instance.set(:map_lineup, map_lineup)
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
