class AddAbbrToNation < ActiveRecord::Migration
  def self.up
    add_column :nations, :abbr, :string

=begin
    [
      ['Belgium',  'BE'],
      ['Brazil',   'BR'],
      ['Bulgaria', 'BG'],
      ['England',  'EL'],
      ['Ecuador',  'EC'],
      ['France',   'FR'],
      ['Germany',  'DE'],
      ['Ireland',  'IE'],
      ['Italy',    'IT'],
      ['Korea',    'KR'],
      ['Netherlands',      'NL'],
      ['Northern Ireland', 'ND'],
      ['Norway',   'NO'],
      ['Poland',   'PL'],
      ['Portugal', 'PT'],
      ['Scotland', 'SS'],
      ['Serbia',   'RS'],
      ['South Africa', 'ZA'],
      ['Wales',    'WL'],
      ['Burundi',  'BI'],
      ['Turkey',   'TR'],
      ['Spain',    'ES'],
    ].each do |name, abbr|
      nation = Nation.find_by_name(name)
      nation.abbr = abbr
      nation.save!
    end
=end
  end

  def self.down
    remove_column :nations, :abbr
  end
end
