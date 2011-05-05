module PlayersHelper

  NUM_NEXT_MATCHES_DISPLAY = Constant.get(:num_next_matches_to_display)
  NO_MATCH_DISPLAY = "(End of Schedule)"

  def next_matches_display(next_matches)
    nexts = next_matches.first(NUM_NEXT_MATCHES_DISPLAY)

    format_rest = "(%d day rest)"
    rests = Array.new
    1.upto(NUM_NEXT_MATCHES_DISPLAY - 1) do |i|
      rests[i] = format_rest % (nexts[i].date_match - nexts[i - 1].date_match - 1) if nexts[i - 1] && nexts[i]
    end
    nexts.uniq!

    nexts << NO_MATCH_DISPLAY
    retval = <<-END
      <table>
        <tr>
          <td><span style="font-size: large">Next Match:</span></td>
          <td colspan="2"><span style="font-size: x-large">
            #{nexts[0]}
          </span></td>
        </tr>
    END
    1.upto(NUM_NEXT_MATCHES_DISPLAY - 1) do |i|
      retval += <<-END
        <tr>
          <td>#{i == 1 ? "Followed by:" : ""}</td>
          <td>#{rests[i]}</td>
          <td style="#{nexts[i] ? "" : "font-style: italic; text-decoration: overline"}">
            #{nexts[i]}
          </td>
        </tr>
      END
    end
    retval += <<-END
      </table>
    END

    return retval.html_safe
  end

  def recent_meetings_display(next_matches, season_id)
    return if next_matches.empty?
    opponent_id = @next_matches.first.opponent_id
    num_meetings = Constant.get(:num_recent_meetings_to_display)
    matches = Match.recent_meetings(opponent_id, num_meetings, @season_id).first(num_meetings)
    html = matches.join("<br />")
    return ("Last Meeting:<br />" + html).html_safe
  end

  def back_from_disabled_on(player, season_id)
    disabled_until = player.disabled_until(@season_id)
    disabled_until_display = disabled_until && (disabled_until + 1.day).strftime("%m/%d")
    return "Back on <font size='-1'><b>#{disabled_until_display}</b></font>".html_safe
  end

  CONTROLLER_OPTIONS_FULL = %w(On Off Assisted Semi Manual)
  CONTROLLER_OPTION_DELIMITER = ','

  def controller_options(match)
    return unless match
    skips_items_with_options_same = Constant.get(:skips_controller_option_items_with_options_same)
    html_rows = Array.new

    SimpleDB.instance.async

    Constant.get(:controller_options).each do |item, options|
      h_options = Hash[*[:H, :A, :N].zip(options).flatten]
      is_options_same = options.uniq.size == 1
      next if is_options_same && skips_items_with_options_same
      option = determine_controller_option(h_options, item, match)
      tr_style = is_options_same ? "" : "font-weight: bold;"
      html_rows << <<-END
        <tr style="#{tr_style}">
          <td>#{item}:</td>
          <td>#{complete_controller_option(option)}</td>
        </tr>
      END
    end

    SimpleDB.instance.sync

    html = <<-END
      <table>
        #{html_rows.join("\n")}
      </table>
    END
    return html.html_safe
  end

    def determine_controller_option(h_options, item, match)
      option = h_options[match.ground[0].upcase.intern]
      raw_options = option.split(CONTROLLER_OPTION_DELIMITER)
      return option if raw_options.size < 2

      option = load_controller_option(match.id, item)
      return option if option

      options_with_prob = raw_options.map { |option| option =~ /([^\d]+)([\d]+)/ && [$1, $2] }
      option = pick_controller_option(options_with_prob)

      save_controller_option(match.id, item, option)

      return option
    end
    private :determine_controller_option

    KEY_FOR_CONTROLLER_OPTIONS_SAVED = :controller_options

    def load_controller_option(match_id, item)
      options_saved = (SimpleDB.instance.get(KEY_FOR_CONTROLLER_OPTIONS_SAVED) || {})[match_id]
      return (options_saved || {})[item]
    end
    private :load_controller_option

    def save_controller_option(match_id, item, option)
      h_saved = SimpleDB.instance.get(KEY_FOR_CONTROLLER_OPTIONS_SAVED) || Hash.new
      h_match = h_saved[match_id] || Hash.new
      h_match[item] = option
      h_saved.clear
      h_saved[match_id] = h_match
      SimpleDB.instance.set(KEY_FOR_CONTROLLER_OPTIONS_SAVED, h_saved)
    end
    private :save_controller_option

    def pick_controller_option(options_with_prob)
      total_prob = options_with_prob.inject(0) { |total, elem| total + elem.last.to_i }
      x = rand(total_prob)
      options_with_prob[0 ... -1].each do |option, prob|
        p = prob.to_i
        return option if x < p
        x -= p
      end
      return options_with_prob.last.first
    end
    private :pick_controller_option

    def complete_controller_option(option)
      candidates = CONTROLLER_OPTIONS_FULL.select { |full| full.starts_with?(option) }
      return case candidates.size
        when 0; "?"
        when 1; candidates.first
        else  ; candidates.join(" or ")
      end
    end
    private :complete_controller_option

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
    ["9 with 2"  , "Exchange #9 with #2"],
    ["21 to 13"  , "Insert #21 before #13"],
    ["loan 15 "  , "Loan/Back from loan #15"],
    ["injure 10" , "Put #10 into injury list"],
    ["recover 7" , "Recover #7 from injury/disabled"],
    ["off"       , "Rest/Put back #11"],
    ["hot 5"     , "Hot/Cool #5"],
    ["notwell 4" , "Not well/Put back #4"],
    ["disable 3" , "Disable/Enable #3"],
    ["until 2 30", "Set date disabled until of #2 at 30 days from next match"],
    ["show 1 ...", "Show (and compare) player's attributes"],
    ["z"         , "Undo last command"],
  ]

  def command_samples_for_roster_chart
    samples = COMMAND_SAMPLES
    num_left = (samples.size / 2.0).ceil
    num_right = samples.size - num_left
    rows = Array.new
    samples.first(num_left).zip(samples.last(num_right)) do |left, right|
      cells = [left, right].map { |values|
        next unless values
        "<td>#{values.first}</td><td>:</td><td>#{values.last}</td>"
      }.join("<td>#{'&nbsp' * 8}</td>")
      rows << "<tr>#{cells}</tr>"
    end
    return content_tag(:table, rows.join("\n").html_safe)
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
    :age_add_inj       => ['AgInj'     , :R],
    :note              => ['Note'      , :L],
  }.freeze
end
