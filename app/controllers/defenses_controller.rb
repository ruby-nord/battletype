class DefensesController < ApplicationController
  def create
    word = params[:word]

    if word.blank?
      head 422
    else
      perfect_typing = params[:perfect_typing]
      defense        = Defenses::Launch.call(player: current_player, word: word, perfect_typing: perfect_typing)

      head 200
    end
  end
end
