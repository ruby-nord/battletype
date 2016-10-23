class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    return render :show if current_player&.game == @game
    return render FullGame.new if enlist.game_full?

    enlist.assign_game_to_player!
    session[:player_id] = enlist.player.id
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
    @enlist ||= Users::Enlist.new(game: @game, player: current_player)
  end

  def game_params
    params.require(:game).permit(:name)
  end
end