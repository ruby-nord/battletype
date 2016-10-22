class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    unless current_player
      return render FullGame.new if enlist.game_full?

      player = enlist.call
      session[:player_id] = player.id
    end
  end

  def create
    game = Games::Create.new(game_params[:name]).call
    redirect_to game_url(game)
  end

  private
  def set_game
    @game = Game.find_by(slug: params[:id]) || Games::Create.new(params[:id]).call
  end

  def enlist
    @enlist ||= Users::Enlist.new(@game)
  end

  def game_params
    params.require(:game).permit(:name)
  end
end