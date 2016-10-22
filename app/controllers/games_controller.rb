class GamesController < ApplicationController
  before_action :set_game

  def show
    unless current_player
      return render FullGame.new if enlist.game_full?

      player = enlist.call
      session[:player_id] = player.id
    end
  end

  private
  def set_game
    @game = begin
      game = Game.where(slug: params[:id]).first
      game = Games::Create.call(params[:id]) if game.nil?
      game
    end
  end

  def enlist
    @enlist ||= Users::Enlist.new(@game)
  end
end