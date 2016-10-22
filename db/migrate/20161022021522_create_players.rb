class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string  :nickname
      t.integer :life
      t.integer :strike_gauge
      t.string  :current_strike

      t.boolean :human,   default: false
      t.boolean :creator, default: false
      t.boolean :won,     default: false

      t.references :game, foreign_key: true, index: true

      t.timestamps
    end
  end
end
