class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_player
  after_action :set_current_user_ip

  def current_player
    return @current_player if @current_player

    player_id = session[:player_id]
    return unless player_id

    @current_player = Player.where(id: player_id).first
  end

  def set_current_player(player)
    session[:player_id] = player.id
    @current_player     = player
  end

  def validate_ssl
    render text: "eaMU_5AJIOniD1eBF9Roqv-2iWaSBmVpR_WXtPJL1tI.d2JGxGGUtUruPVhS0-4avN4ipyP01YK8ZOLg_Q5QZpk"
  end

  #Write for every requests : hard on performance, but ok for hackathon
  def set_current_user_ip
    current_player&.update(last_ip: request.remote_ip)
  end
end
