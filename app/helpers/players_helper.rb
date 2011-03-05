module PlayersHelper

  def player_html_class(player, season_id, injury_list, off_list)
    return player.hot?(season_id)          ? 'hot' \
         : player.on_loan?(season_id)      ? 'on_loan' \
         : player.disabled?(season_id)     ? 'disabled' \
         : injury_list.include?(player.id) ? 'injury_list' \
         : off_list.include?(player.id)    ? 'off_list' \
                                           : ''
  end

  NUM_NEXT_MATCHES_DISPLAY = Constant.get(:num_next_matches_to_display)
  NO_MATCH_DISPLAY = "(End of Schedule)"

  def next_matches_display(next_matches)
    nexts = next_matches[0, NUM_NEXT_MATCHES_DISPLAY]

    format_rest = "(%d day rest)"
    rests = Array.new
    1.upto(NUM_NEXT_MATCHES_DISPLAY - 1) do |i|
      rests[i] = format_rest % (nexts[i].date_match - nexts[i - 1].date_match - 1) if nexts[i - 1] && nexts[i]
    end
    nexts.uniq!

    retval = <<-END
      <table>
        <tr>
          <td><span style="font-size: large">Next Match:</span></td>
          <td colspan="2"><span style="font-size: x-large">
            #{nexts[0] || NO_MATCH_DISPLAY}
          </span></td>
        </tr>
    END
    1.upto(nexts.size - 1) do |i|
      retval += <<-END
        <tr>
          <td>#{i == 1 ? "Followed by:" : ""}</td>
          <td>#{rests[i]}</td>
          <td style="#{nexts[i] ? "" : "font-style: italic; text-decoration: overline"}">
            #{nexts[i] || NO_MATCH_DISPLAY}
          </td>
        </tr>
      END
    end
    retval += <<-END
      </table>
    END

    return retval.html_safe
  end

  def back_from_disabled_on(player, season_id)
    disabled_until = player.disabled_until(@season_id)
    disabled_until_display = disabled_until && (disabled_until + 1.day).strftime("%m/%d")
    return "Back on <font size='-1'><b>#{disabled_until_display}</b></font>".html_safe
  end

  CONTROLLER_OPTIONS = [
    #                               Home         Away         Neutral
    ["Difficulty Level"        , %w(Semi-Pro     Professional Semi-Pro    )],
    ["Passing Power Assistance", %w(Off          On           Off         )],
    ["Pass Assistance"         , %w(Semi         Assisted     Semi        )],
    ["Through Pass Assistance" , %w(Assisted     Assisted     Manual      )],
    ["Shot Assistance"         , %w(Semi         Assisted     Semi        )],
    ["Cross Assistance"        , %w(Semi         Assisted     Semi        )],
    ["Lob Pass Assistance"     , %w(Assisted     Assisted     Manual      )],
    ["Save Assistance"         , %w(Semi         Assisted     Manual      )],
  ]

  def controller_options(match)
    html_rows = Array.new
    CONTROLLER_OPTIONS.each do |item, options|
      next if options.uniq.size == 1
      h_options = Hash[*[:H, :A, :N].zip(options).flatten]
      html_rows << <<-END
        <tr>
          <td>#{item}:</td>
          <td><b>#{h_options[match.ground[0].upcase.intern]}</b></td>
        </tr>
      END
    end
    html = <<-END
      <table>
        #{html_rows.join("\n")}
      </table>
    END
    return html.html_safe
  end

  def column_index(column_name)
    return column_attribute(column_name, 0)
  end

  DEFAULT_ALIGN = 'left'
  HASH_ALIGN = {:L => 'left', :R => 'right', :C => 'center'}

  def column_align(column_name)
    align = column_attribute(column_name, 1)
    return HASH_ALIGN[align] || DEFAULT_ALIGN
  end

  def column_attribute(column_name, index)
    attributes = COLUMN_ATTRIBUTES[column_name.intern]
    return nil unless attributes
    return attributes[index]
  end

  def displaying_player_attribute_names
    # [nil] to instruct to output <br />
    return \
        ColumnFilter::GENERAL_ATTRIBUTE_NAMES_1   + ColumnFilter::GENERAL_ATTRIBUTE_NAMES_2   + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_1 + [nil] \
      + ColumnFilter::OFFENSIVE_ATTRIBUTE_NAMES_2 + [nil] \
      + ColumnFilter::DEFENSIVE_ATTRIBUTE_NAMES   + ColumnFilter::GOALKEEPING_ATTRIBUTE_NAMES
  end

  def prepare_superior_attribute_values
    values = Hash.new { |h, k| h[k] = 0 }
    if @players.size == 2
      attrs1 = @players[0].player_attribute
      attrs2 = @players[1].player_attribute
      @attribute_columns.map(&:name).each do |attr_name|
        value1 = attrs1.read_attribute(attr_name)
        value2 = attrs2.read_attribute(attr_name)
        values[attr_name] = value1 > value2 ? value1 : value2
      end
    end

    return values
  end

  def html_class_for_attribute_display(attr_name, value, is_leftmost)
    clazz = ''
    clazz =  'leftmost_of_attributes' if is_leftmost
    clazz += ' sorted_field'    if @sorted_field_names.include?(attr_name)
    top_five = @attribute_top_five_values[attr_name]
    clazz += ' top_five_values' if ! top_five.nil? && value >= top_five
    superior_value = @superior_attribute_values[attr_name]
    clazz += ' superior_attribute_value' if superior_value > 0 and value >= superior_value
    return clazz
  end

  def options_for_attrs_and_props(attrs_and_props)
    return attrs_and_props.map { |x| [column_name2display(x).titleize, x.to_s] }
  end

  COMMAND_SAMPLES = [
    ["9 with b2" , "Exchange 'Starter 9' with 'Bench 2'"],
    ["r21 to r13", "Insert 'Reserve 21' before 'Reserve 13'"],
    ["loan r15"  , "Loan/Back from loan 'Reserve 15'"],
    ["injure 10" , "Put 'Starter 10' into injury list"],
    ["recover 7" , "Recover 'Starter 7' from injury list"],
    ["off"       , "Rest/Put back 'Starter 11'"],
    ["hot 5"     , "Hot/Cool 'Starter 5'"],
    ["disable 3" , "Disable/Enable 'Starter 3'"],
    ["show 1 ...", "Show (and compare) player's attributes"],
  ]

  def command_samples_for_roster_chart
    rows = COMMAND_SAMPLES.map { |c, ex| "<tr><td>#{c}</td><td>:</td><td>#{ex}</td></tr>" }.join("\n").html_safe
    return content_tag(:table, rows)
  end

  COLUMN_ATTRIBUTES = {
    :id                => ['id'        , :R],
    :name              => ['Name'      , :L],
    :first_name        => ['First Name', :L],
    :number            => ['No'        , :C],
    :position_id       => ['Positions' , :L],
    :skill_move        => ['Skill'     , :L],
    :is_right_dominant => ['Ft'        , :C],
    :both_feet_level   => ['Weak Ft'   , :L],
    :height            => ['H'         , :R],
    :weight            => ['W'         , :R],
    :birth_year        => ['Ag'        , :R],
    :nation_id         => ['Nation'    , :L],
    :overall           => ['Ov'        , :R],
    :market_value      => ['MV'        , :R],
    :wage              => ['Wage'      , :R],
    :note              => ['Note'      , :L],
  }.freeze
end
