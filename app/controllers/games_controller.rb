class GamesController < ApplicationController
  before_action :set_game,  only: [:show]
  before_action :join_game, only: [:show], unless: :player_in_game?

  def show
    @opponent ||= @game.players.where.not(id: current_player&.id).first || NilPlayer.new
    return render FinishedGame.template_path if @game.state == 'finished'
  end

  def create
    game = Games::Create.new(game_params[:name]).call
    redirect_to game_url(game)
  end

  private

  def join_game
    return if @game.state == 'finished'
    enlist  = Players::Enlist.new(game: @game, player: current_player)

    if enlist.game_full?
      return render FullGame.template_path
    else
      return render AwaitingOpponentGame.template_path
    end
  end

  def player_in_game?
    current_player && current_player.game == @game
  end

  def set_game
    @game = Game.find_by(slug: params[:id].parameterize)
    redirect_to root_path unless @game
  end

  def game_params
    params.require(:game).permit(:name)
  end
end
