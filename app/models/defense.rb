class Defense
  include ActiveModel::Validations

  validate :attacker_ship_exists, :matching_case_sensitive, :not_matching_own_ship

  private
  attr_reader :player, :perfect_typing, :word

  public

  def initialize(player:, word:, perfect_typing:)
    @player         = player
    @word           = word
    @perfect_typing = ['1', true].include?(perfect_typing)
  end

  def ship
    @ship ||= player.game.ships.joins(:word).where("LOWER(words.value) = LOWER(?)", word).first
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
    unless ship
      errors.add(:word, "not_found")
    end
  end

  def matching_case_sensitive
    matching_insensitive = player.game.ships.joins(:word).where.not(player_id: player.id).where("LOWER(words.value) = LOWER(:word) AND words.value != :word", word: word).exists?

    if matching_insensitive
      errors.add(:word, "wrong_case")
    end
  end

  def not_matching_own_ship
    matching = player.game.ships.joins(:word).where(player_id: player.id).where(words: { value: word }).exists?

    if matching
      errors.add(:word, "player_ship")
    end
  end
end
