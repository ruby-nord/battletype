ActiveAdmin.register Game do
  permit_params :name, :invitation_token

  form do |f|
    inputs 'Details' do
      input :name
      input :invitation_token
    end

    actions
  end

  index do
    selectable_column

    column :id
    column :name
    column :players do |game|
      player_1, player_2 = game.players

      a player_1.nickname, href: admin_player_path(player_1)
      text_node "VS"
      a player_2.nickname, href: admin_player_path(player_2)
    end

    column :ships do |game|
      game.words.count
    end

    column :state
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :invitation_token
      row :state
      row :created_at
      row :updated_at
    end

    panel 'Players' do
      table_for game.players do
        column :nickname
        column :life
        column :strike_gauge
        column :unlocked_strike
        column :ships do |player|
          player.ships.count
        end
        column :game
        column :human
        column :creator
        column :won
        column :updated_at
      end
    end

    panel 'Ships' do
      table_for game.ships do
        column :player do |ship|
          link_to ship.player&.nickname, admin_player_path(ship.player)
        end

        column :word do |ship|
          ship.word.value
        end

        column :damage
        column :velocity
        column :state
        column :created_at
        column :updated_at
      end
    end

    active_admin_comments
  end
end
