class AddControllerCustomizationAdjustToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :controller_customization_adjust, :integer, :default => nil
  end
end
