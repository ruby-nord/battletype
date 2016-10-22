class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :invitation_token
      t.string :state

      t.timestamps
    end

    add_index :games, [:name, :invitation_token]
  end
end
