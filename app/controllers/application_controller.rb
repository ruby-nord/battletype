class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_player, :opponent

  def current_player
    player_id = session[:player_id]
    return unless player_id

    @current_player ||= Player.where(id: player_id).first
  end

  def current_game
    Game.find_by(slug: params[:id].parameterize)
  end

  def opponent
    current_game.players.where.not(id: current_player.id).first || NilPlayer.new
  end
end
