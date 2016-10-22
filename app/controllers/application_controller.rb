class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_player
    player_id = session[:player_id]
    return unless player_id

    @current_player ||= Player.where(id: player_id).first
  end
end
