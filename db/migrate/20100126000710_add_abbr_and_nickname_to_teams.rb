class AddAbbrAndNicknameToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :abbr    , :string
    add_column :teams, :nickname, :string

=begin
    DATA.each do |name, abbr, nickname|
      team = Team.find_by_name(name)
      team.abbr     = abbr
      team.nickname = nickname
      team.save!
    end
=end
  end

  def self.down
    remove_column :teams, :abbr
    remove_column :teams, :nickname
  end

  DATA = [
    ["Manchester United"   , "Man. Utd." , "The Red Devils"],
    ["Liverpool"           ,  nil        , "The Reds"      ],
    ["Chelsea"             ,  nil        , "The Pensioners"],
    ["Arsenal"             ,  nil        , "The Gunners"   ],
    ["Everton"             ,  nil        , "The Toffees"   ],
    ["Aston Villa"         , "Aston V."  , "The Villa"     ],
    ["Tottenham Hotspur"   , "Tottenham" , "Spurs"         ],
    ["Manchester City"     , "Man. City" , "The Citizens"  ],
    ["Fulham"              ,  nil        , "The Cottagers" ],
    ["West Ham United"     , "West Ham"  , "The Hammers"   ],
    ["Wigan Athletic"      , "Wigan"     , "Latics"        ],
    ["Stoke City"          , "Stoke"     , "The Potters"   ],
    ["Bolton Wanderers"    , "Bolton"    , "The Trotters"  ],
    ["Portsmouth"          ,  nil        , "Pompey"        ],
    ["Blackburn Rovers"    , "Blackburn" , "Rovers"        ],
    ["Sunderland"          ,  nil        , "The Black Cats"],
    ["Hull City"           , "Hull"      , "The Tigers"    ],
    ["Wolverhampton"       , "Wolves"    , "Wolves"        ],
    ["Birmingham City"     , "Birmingham", "Blues"         ],
    ["Burnley"             ,  nil        , "The Clarets"   ],
    ["Newcastle United"    , "Newcastle" , "The Magpies"   ],
    ["Derby County"        , "Derby"     , "The Rams"      ],
    ["Leeds United"        , "Leeds Utd.", "The Whites"    ],
    ["Norwich City"        , "Norwich"   , "The Canaries"  ],
    ["West Bromwich Albion", "West Brom.", "The Baggies"   ],
    ["Nottingham Forest"   , "Nottingham", "Forest"        ],
    ["Cardiff City"        , "Cardiff"   , "The Bluebirds" ],
    ["Sheffield United"    , "Sheffield" , "The Blades"    ],
    ["Ipswich Town"        , "Ipswich"   , "Town"          ],
    ["Dagenham & Redbridge", "Dag & Red" , "The Daggers"   ],
    ["Standard Liege"      , "Std. Liege", "Les Rouches"   ],
    ["Galatasaray SK"      , "Galatasary", "Cim Bom"       ],
    ["Alkmaar Zaanstreek"  , "AZ"        , "AZ"            ],
    ["Atletico Madrid"     , "Atletico M", "Los colchoneros"],
    ["Middlesbrough"       , "Middlesbr.", "The Boro"      ],
    ["Bradford Park Avenue", "Bradfrd PA", "The Avenue"    ],
    ["Coventry City"       , "Coventry"  , "The Sky Blues" ],
    ["Swansea City"        , "Swansea"   , "The Swans"     ],
    ["Leicester City"      , "Leicester" , "The Foxes"     ],
    ["Crystal Palace"      , "Crystal P.", "The Eagles"    ],
    ["AC Milan"            ,  nil        , "Rossoneri"     ],
    ["Besiktas"            ,  nil        , "Kara Kartallar"],
    ["VfL Wolfsburg"       , "Wolfsburg" , "Die Wolfe"     ],
    ["CSKA Moscow"         , "CSKA Mscow", "Koni"          ],
  ]
end
