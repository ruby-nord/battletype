class DefensesController < ApplicationController
  def create
    word = params[:word]

    if word.blank?
      head 422
    else
      perfect_typing = params[:perfect_typing]
      payload        = Defenses::Launch.call(player: current_player, word: word, perfect_typing: perfect_typing)

      ActionCable.server.broadcast "game_#{current_player.game_id}", payload
      head 200
    end
  end
end
