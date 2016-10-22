class GamesController < ApplicationController
  before_action :set_game

  def show
    Users::Enlist.call(@game)
  end

  private
  def set_game
    @game = Game.find(params[:id])
  end
end