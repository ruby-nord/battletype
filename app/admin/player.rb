ActiveAdmin.register Player do
  permit_params :nickname

  form do |f|
    inputs 'Details' do
      input :nickname
    end

    actions
  end

  index do
    selectable_column

    column :id

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

    actions
  end

  show do
    attributes_table do
      row :id
      row :nickname
      row :life
      row :strike_gauge
      row :unlocked_strike
      row :ships do |player|
        player.ships.count
      end
      row :game
      row :human
      row :creator
      row :won
      row :last_ip
      row :created_at
      row :updated_at
    end

    panel 'Ships' do
      table_for player.ships do
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
end
