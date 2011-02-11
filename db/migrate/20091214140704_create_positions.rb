class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.column :name    , :string , :null => false
      t.column :category, :string , :null => false
    end

=begin
    [
      ['GK' , 'Goalkeeper'],
      ['SW' , 'Defender'],
      ['CB' , 'Defender'],
      ['RB' , 'Defender'],
      ['LB' , 'Defender'],
      ['RWB', 'Defender'],
      ['LWB', 'Defender'],
      ['CDM', 'Midfielder'],
      ['CM' , 'Midfielder'],
      ['RM' , 'Midfielder'],
      ['LM' , 'Midfielder'],
      ['CAM', 'Midfielder'],
      ['RW' , 'Forward'],
      ['LW' , 'Forward'],
      ['CF' , 'Forward'],
      ['RF' , 'Forward'],
      ['LF' , 'Forward'],
      ['ST' , 'Forward'],
    ].each do |name, category|
      Position.create :name => name, :category => category
    end
=end
  end

  def self.down
    drop_table :positions
  end
end
