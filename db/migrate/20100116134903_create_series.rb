class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :name, :null => false
      t.string :abbr
    end

=begin
    [
      ["UEFA Champions League", "UEFA CL"     ],
      ["UEFA Europa League"   , "UEFA EL"     ],
      ["UEFA Super Cup"       , "UEFA SC"     ],
      ["Premier League"       , "Premier"     ],
      ["FA Cup"               , "FA Cup"      ],
      ["Carling Cup"          , "Carling C."  ],
      ["Community Shield"     , "C. Shield"   ],
      ["League Championship"  , "Championship"],
    ].each do |name, abbr|
      Series.create(:name => name, :abbr => abbr)
    end
=end
  end

  def self.down
    drop_table :series
  end
end
