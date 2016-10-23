class AddIpToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :last_ip, :string, null: true
  end
end
