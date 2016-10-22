class DefensesController < ApplicationController
  def create
    word = params[:word]
    return head 422 if word.blank?

    defense = Defenses::Launch.call(current_player, word)

    if defense.valid?
      head 200
    else
      head 422
    end
  end
end
