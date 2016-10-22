ActiveAdmin.register Word do
  permit_params :value

  form do |f|
    inputs 'Details' do
      input :value
    end

    actions
  end

  index do
    selectable_column

    column :id
    column :value
    column :game
    column :player do |word|
      link_to word.ship.player.nickname, admin_player_path(word.ship.player)
    end
    column :created_at

    actions
  end
end
