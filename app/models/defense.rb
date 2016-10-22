class Defense
  private
  attr_reader :player, :word

  public
  attr_reader :ship

  def initialize(player, word)
    @player = player
    @word   = word
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
