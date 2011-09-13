class Season < ActiveRecord::Base
  belongs_to :chronicle
  belongs_to :team, :polymorphic => true
  has_many :player_seasons
  has_many :players, :through => :player_seasons
  has_many :season_series
  has_many :series, :through => :season_series
  has_many :matches
  belongs_to :formation

  validates_presence_of     :year_start
  validates_numericality_of :year_start, :only_integer => true, :greater_than_or_equal_to => 1990
  validates_uniqueness_of   :year_start, :scope => [:chronicle_id, :team_id]

  MONTH_START = 7

  def self.list(chronicle_id)
    seasons = find_all_by_chronicle_id(chronicle_id)
    return seasons.sort.reverse
  end

  def club_team?
    return team_type == 'Team'
  end

  def national_team?
    return team_type == 'Nation'
  end

  def year_end
    return year_start + 1
  end

  def years
    return year_start.to_s + (club_team? ? "-#{year_end}" : "")
  end

  def prev_season
    seasons = chronicle.seasons.sort_by { |season| season.year_start }
    index = seasons.index(self)
    return index == 0 ? nil : seasons[index - 1]
  end

  def name_and_years
    return "#{team.name} #{years}"
  end

  def succeed_players(season_from, creates_clones=false)
    if creates_clones && ! player_seasons.empty?
      raise "Nothing can be done because self.player_seasons has data"
    end

    season_from.player_seasons.each do |player_season|
      unless creates_clones
        player_seasons.build(player_season.attributes_to_succeed)
      else
        player_season_clone = player_season.clone
        raise "player_season_clone is persisted.  Check the code" if player_season_clone.persisted?
        player_clone = player_season.player.clone
        raise "player_clone is persisted.  Check the code" if player_clone.persisted?

        player_clone.player_attribute = PlayerAttribute.zeros
        player_season_clone.player = player_clone
        player_season_clone.season = self
        player_clone.save!
        player_seasons << player_season_clone
      end
    end
  end

  def <=>(other)
    return self.year_start <=> other.year_start
  end
end
