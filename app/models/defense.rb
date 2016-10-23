class Defense
  include ActiveModel::Validations

  validate :attacker_ship_exists

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

  def unlocked_strike
    current_strike = player.unlocked_strike
    next_strike    = Strike.reward_for(strike_gauge)

    [current_strike, next_strike].compact.max { |strike| Strike::ALL.index(strike.to_s) }
  end

  private

  def attacker_ship_exists
    return if @ship

    ships = player.game.ships.joins(:word)
    @ship = ships.where.not(player_id: player.id).where(words: { value: word }).first
    return if @ship

    if matching_case_sensitive?
      errors.add(:word, "wrong_case")
    elsif matching_own_ship?
      errors.add(:word, "player_ship")
    else
      errors.add(:word, "not_found")
    end
  end

  def matching_case_sensitive?
    player.game.ships.joins(:word).where.not(player_id: player.id).where("LOWER(words.value) = LOWER(?)", word).exists?
  end

  def matching_own_ship?
    player.game.ships.joins(:word).where(player_id: player.id).where(words: { value: word }).exists?
  end
end
