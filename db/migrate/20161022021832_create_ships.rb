class CreateShips < ActiveRecord::Migration[5.0]
  def change
    create_table :ships do |t|
      t.integer :damage
      t.float   :velocity
      t.string  :state

      t.references :player, foreign_key: true, index: true
      t.references :word,   foreign_key: true, index: true

      t.timestamps
    end
  end
end
