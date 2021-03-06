ActiveAdmin.register Game do
  permit_params :name

  form do |f|
    inputs 'Details' do
      input :name
    end

    actions
  end

  index do
    selectable_column

    column :id

    column :name do |game|
      link_to game.name, admin_game_path(game)
    end

    column :players do |game|
      player_1, player_2 = game.players

      if player_1
        a player_1.nickname, href: admin_player_path(player_1)
      else
        text_node '-'
      end

      text_node " VS "

      if player_2
        a player_2.nickname, href: admin_player_path(player_2)
      else
        text_node '-'
      end
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
      row :slug
      row :state
      row :created_at
      row :updated_at
    end

    panel 'Players' do
      table_for game.players do
        column :nickname do |player|
          link_to player.nickname, admin_player_path(player)
        end

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
        column :last_ip
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

        column :ship_type
        column :damage
        column :velocity
        column :state
        column :created_at
        column :updated_at
      end
    end

    active_admin_comments
  end

  controller do
    def find_resource
      scoped_collection.find_by_slug(params[:id]) || super
    end
  end

end
