ActiveAdmin.register Ship do
  index do
    selectable_column

    column :id

    column :word do |ship|
      link_to ship.word.value, admin_ship_path(ship)
    end

    column :ship_type
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
