class GameExhibit < SimpleDelegator
  def initialize(game, current_player)
    @current_player = current_player
    super(game)
  end
  
  def to_partial_path
    case
    when finished?
      "games/finished_game"
    when awaiting_opponent? && player_is_not_part_of_the_game?
      "games/awaiting_opponent_game"
    when running? && player_is_not_part_of_the_game?
       "games/full_game"
     else
       super
    end
  end
  
  def current_player
    @current_player
  end
  
  def opponent
    players.where.not(id: current_player&.id).first || NilPlayer.new
  end
  
   # this method must **not** be delegated to the underlying model; otherwise,
   # when the object is rendered by `ActionView::PartialRenderer` (eg. when calling `render` from a view), 
   # `to_partial_path` will be sent to the actual model instead of the exhibit
  def to_model
    self
  end

  def class
    __getobj__.class
  end
  
  private
  
  def player_is_not_part_of_the_game?
    ! player_is_part_of_the_game?
  end
  
  def player_is_part_of_the_game?
    @current_player&.plays_in?(__getobj__)
  end
end
