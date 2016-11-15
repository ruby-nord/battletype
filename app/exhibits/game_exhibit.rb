class GameExhibit < SimpleDelegator
  def initialize(game, current_player)
    @current_player = current_player
    super(game)
  end
  
  def to_partial_path
    case state
    when "finished"
      "games/finished_game"
    when "awaiting_opponent"
      player_in_game? ? super : "games/awaiting_opponent_game"
    when "running"
      player_in_game? ? super : "games/full_game"
    end
  end
  
  def to_model
    __getobj__
  end
  
  def class
    __getobj__.class
  end
  
  private
  
  def player_in_game?
    @current_player && @current_player.game == __getobj__
  end
end
