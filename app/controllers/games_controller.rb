class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    @game = GameExhibit.new(@game, current_player)
  end

  def create
    game    = Games::Create.new(game_params[:name]).call
    @enlist = Players::Enlist.new(game: game, player: current_player)

    enlist_player
    redirect_to game_url(game)
  end

  private

  def enlist_player
    return unless @enlist.available?
    payload = @enlist.assign_game_to_player!

    set_current_player(@enlist.player)
    ActionCable.server.broadcast "game_#{current_player.game_id}", payload
  end

  def game_params
    params.require(:game).permit(:name)
  end

  def set_game
    @game = Game.find_by(slug: params[:id].parameterize)
    redirect_to root_path unless @game
  end
end
