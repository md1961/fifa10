class AddIsDisabledEtcToPlayerSeasons < ActiveRecord::Migration
  def self.up
    add_column :player_seasons, :is_disabled   , :boolean, :null => false, :default => false
    add_column :player_seasons, :disabled_until, :date
    add_column :player_seasons, :diagnosis     , :string
  end

  def self.down
    remove_column :player_seasons, :diagnosis
    remove_column :player_seasons, :disabled_until
    remove_column :player_seasons, :is_disabled
  end
end
