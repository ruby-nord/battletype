class PlayersController < ApplicationController
  before_action :set_player

  def update
    return render json: { error: "Cannot update another user" }, status: 401 if @player != current_player

    @player.update(player_params)

    payload = {
      code:      "successful_player_nickname_update",
      player_id: @player.id,
      nickname:  @player.nickname
    }

    ActionCable.server.broadcast "game_#{current_player.game_id}", payload
    head 200
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:nickname)
  end
end
