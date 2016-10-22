class SetStrikeGaugeDefaultForPlayers < ActiveRecord::Migration[5.0]
  def up
    change_column_default :players, :strike_gauge, 0
  end

  def down
    change_column_default :players, :strike_gauge, nil
  end
end
