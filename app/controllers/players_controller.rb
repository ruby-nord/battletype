class PlayersController < ApplicationController
  before_action :set_player

  def update
    return render json: { error: "Cannot update another user" }, status: 401 if @player != current_player

    @player.update(player_params)
    render json: { status: :ok }, status: 200
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:nickname)
  end
end
