class Bomb
  include ActiveModel::Validations

  validate :game_running, :ship_exists, :not_matching_attacked_player_ship

  private
  attr_reader :player, :word

  public
  def initialize(player:, word:)
    @player = player
    @word   = word
  end

  def ship
    @ship ||= ships.where(words: { value: word }).first
  end

  private

  def game_running
    unless player.game.state == 'running'
      errors.add(:game, "not_running")
    end
  end

  def not_matching_attacked_player_ship
    matching = ships.where.not(player_id: player.id).where(words: { value: word }).exists?

    if matching
      errors.add(:word, "attacked_player_ship")
    end
  end

  def ship_exists
    unless ship
      errors.add(:word, "ship_not_found")
    end
  end

  def ships
    player.game.ships.joins(:word)
  end
end
