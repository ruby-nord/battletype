class AddSlugToGame < ActiveRecord::Migration[5.0]
  def up
    remove_column :games, :invitation_token #index is automatically removed in rails 4
    add_column :games, :slug, :string
    add_index  :games, [:slug]
    Game.find_each do |game|
      game.update(slug: game.name.parameterize)
    end
  end

  def down
    add_column :games, :invitation_token, :string #index is automatically removed in rails 4
    remove_column :games, :slug
  end
end
