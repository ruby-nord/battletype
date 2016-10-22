class Defense
  private
  attr_reader :player, :perfect_typing, :word

  public
  attr_reader :ship

  def initialize(player:, word:, perfect_typing:)
    @player         = player
    @word           = word
    @perfect_typing = ['1', true].include?(perfect_typing)
  end

  def strike_gauge
    if perfect_typing
      [player.strike_gauge + word.size, 100].min
    else
      0
    end
  end

  def valid?
    @ship ||= look_for_attacker_ship

    @ship.present?
  end

  private

  def look_for_attacker_ship
    player.game.ships.joins(:word).where.not(player_id: player.id).where(words: { value: word }).first
  end
end
