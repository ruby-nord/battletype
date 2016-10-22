class DefensesController < ApplicationController
  def create
    word = params[:word]
    return head 422 if word.blank?

    perfect_typing = params[:perfect_typing]
    defense        = Defenses::Launch.call(player: current_player, word: word, perfect_typing: perfect_typing)

    if defense.valid?
      head 200
    else
      head 422
    end
  end
end
