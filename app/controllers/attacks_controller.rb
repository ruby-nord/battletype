class AttacksController < ApplicationController
  def create
    word = params[:word]
    
    if word.blank?
      head 422
    else
      ActionCable.server.broadcast "game_#{params[:game_id]}", Attacks::Launch.call(current_player, word)
      head 200
    end
  end
end
