class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    @opponent ||= @game.players.where.not(id: current_player&.id).first || NilPlayer.new
    render game_template || :show
  end

  def create
    game = Games::Create.new(game_params[:name]).call
    redirect_to game_url(game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def game_template
    case @game.state
    when 'awaiting_opponent'
      return if player_in_game?
      AwaitingOpponentGame.template_path
    when 'running'
      return if player_in_game?
      FullGame.template_path
    when 'finished'
      FinishedGame.template_path
    end
  end

  def player_in_game?
    current_player && current_player.game == @game
  end

  def set_game
    @game = Game.find_by(slug: params[:id].parameterize)
    redirect_to root_path unless @game
  end
end
