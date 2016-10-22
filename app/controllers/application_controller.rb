class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def current_player
    player_id = session[:player_id]
    return unless player_id

    @current_player ||= Player.find(player_id)
  end

  def post_sample_message
    game_id = params["game_id"]
    user_id = params["user_id"]
    message = params["message"]
    Rails.logger.info "Post #{message} to user #{user_id}"
    ActionCable.server.broadcast("game_#{game_id}", {message: message, user: user_id})
    render json: {status: :ok}
  end
end
