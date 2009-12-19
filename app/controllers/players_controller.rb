class PlayersController < ApplicationController

  def list
    team_id = 1
    @team = Team.find(team_id)

    @players = Player.find_all_by_team_id(team_id)

    @page_title = "#{@team.name} Rosters"
  end

  def show_attribute_legend
    @abbrs_with_full = PlayerAttribute.abbrs_with_full

    @page_title = "Player Attribute Legend"
  end
end
