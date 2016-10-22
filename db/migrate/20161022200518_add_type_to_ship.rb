class AddTypeToShip < ActiveRecord::Migration[5.0]
  def change
    add_column :ships, :ship_type, :string
  end
end
