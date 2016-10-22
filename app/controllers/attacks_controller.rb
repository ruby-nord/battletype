class AttacksController < ApplicationController
  def create
    word = params[:word]
    return head 422 if word.blank?

    attack = Attacks::Launch.call(current_player, word)

    if attack.valid?
      ActionCable.server.broadcast("game_#{params[:game_id]}", {ships: current_player.ships.to_json})
      head 200
    else
      head 422
    end
  end
end
