ActiveAdmin.register Ship do
  index do
    selectable_column

    column :id
    column :word do |ship|
      ship.word.value
    end
    column :damage
    column :velocity
    column :game do |ship|
      link_to ship.player.game.name, admin_game_path(ship.player.game)
    end
    column :player do |ship|
      link_to ship.player.nickname, admin_player_path(ship.player)
    end
    column :state
    column :created_at
    column :updated_at

    actions
  end
end
