class AttacksController < ApplicationController
  def create
    word = params[:word]
    return head 422 if word.blank?

    attack = Attacks::Launch.call(current_player, word)

    if attack.valid?
      ActionCable.server.broadcast("game_#{params[:game_id]}", {ships: current_player.ships.to_json})
    else
      ActionCable.server.broadcast("game_#{params[:game_id]}", { player: current_player.nickname, invalid_word: word })
    end
    
    head 200
  end
end
