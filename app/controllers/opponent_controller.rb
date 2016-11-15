class OpponentController < ApplicationController
  before_action :set_game,  only: [:create]

  def create
    @enlist = Players::Enlist.new(game: @game, player: current_player)
    enlist_player if @enlist.available?

    redirect_to game_path(@game)
  end

  private

  def enlist_player
    payload = @enlist.assign_game_to_player!
    set_current_player(@enlist.player)
    ActionCable.server.broadcast "game_#{current_player.game_id}", payload
  end

  def set_game
    @game = Game.find_by(slug: params[:game_id].parameterize)
    return redirect_to root_path unless @game
  end
end
