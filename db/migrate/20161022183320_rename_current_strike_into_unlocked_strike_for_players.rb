class RenameCurrentStrikeIntoUnlockedStrikeForPlayers < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :current_strike, :unlocked_strike
  end
end
