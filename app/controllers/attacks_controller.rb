class AttacksController < ApplicationController
  def create
    word = params[:word]

    if word.blank?
      head 422
    else
      payload = Attacks::Launch.call(player: current_player, word: word)
      ActionCable.server.broadcast "game_#{current_player.game_id}", payload
      head 200
    end
  end
end
