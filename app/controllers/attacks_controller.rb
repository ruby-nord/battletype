class AttacksController < ApplicationController
  def create
    word = params[:word]
    return head 422 if word.blank?

    attack = Attacks::Launch.call(current_player, word)

    if attack.valid?
      head 200
    else
      head 422
    end
  end
end
