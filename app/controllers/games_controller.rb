class GamesController < ApplicationController
  before_action :set_game

  def show
    unless current_player
      player = Users::Enlist.call(@game)
      session[:player_id] = player.id
    end
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end
end