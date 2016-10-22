class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :value

      t.references :game, foreign_key: true, index: true

      t.timestamps
    end

    add_index :words, :value
  end
end
