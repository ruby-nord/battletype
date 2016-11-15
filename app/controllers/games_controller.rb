class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    @game = GameExhibit.new(@game, current_player)
  end

  def create
    game = Games::Create.new(game_params[:name]).call
    redirect_to game_url(game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def set_game
    @game = Game.find_by(slug: params[:id].parameterize)
    redirect_to root_path unless @game
  end
end
