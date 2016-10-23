class BombingsController < ApplicationController
  def create
    word = params[:word]

    if word.blank?
      head 422
    else
      attacked_player = current_player
      attacker        = current_player.game.players.where.not(id: current_player.id).first

      payloads = Bombs::Drop.call(player: attacker, word: word)

      payloads.each do |payload|
        ActionCable.server.broadcast "game_#{current_player.game_id}", payload
      end

      head 200
    end
  end
end

