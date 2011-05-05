module RosterChartsHelper

  def player_html_class(player, season_id, injury_list, off_list)
    return '' if player.nil_player?

    return player.on_loan?(season_id)       ? 'on_loan' \
         : player.back_for_next?(season_id) ? 'back_for_next' \
         : player.disabled?(season_id)      ? 'disabled' \
         : injury_list.include?(player.id)  ? 'injury_list' \
         : off_list.include?(player.id)     ? 'off_list' \
                                            : ''
  end

  def player_index_html_class(player, season_id)
    return '' if player.nil_player?

    return player.hot?(season_id)      ? 'hot' \
         : player.not_well?(season_id) ? 'not_well' \
                                       : ''
  end

  def number_of_players_display
    s = "Total of #{@players.size} players "
    num_inj, list_name = Constant.get(:uses_disable_only_mode) \
                           ? [@players.count { |player| player.disabled?(@season_id) }, 'disabled list']
                           : [@injury_list.size                                       , 'injury list'  ]
    s += "(#{pluralize(num_inj, 'player')} in #{list_name})"

    return s
  end
end

