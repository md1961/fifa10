class RosterChartsController < ApplicationController

  def index
    @season_id = get_season_id(params)
    @is_lineup = params[:is_lineup] == '1'

    unless @is_lineup
      set_players_to_row_filter_if_not

      if session[:ticket_to_examine_player_status_change]
        examine_player_status_change
        session[:ticket_to_examine_player_status_change] = nil
      end
      recover_disabled
    end

    report = session[:roster_chart_report]
    session[:roster_chart_report] = nil
    flash[:report] = report && report.html_safe

    @error_explanation = session[:error_explanation]
    session[:error_explanation] = nil

    @season = Season.find(@season_id)
    @formation = @season.formation

    SimpleDB.instance.async

    @players = players_of_team(includes_on_loan=true, for_lineup=@is_lineup)

    SimpleDB.instance.sync

    @next_matches = Match.nexts(@season_id)

    @num_starters, @num_in_bench = get_num_starters_and_in_bench

    @injury_list = get_injury_list
    @off_list    = get_off_list

    @page_title_size = 3
    @page_title = "#{team_name_and_season_years} Roster Chart"
  end
end
