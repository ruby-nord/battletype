class Defense
  include ActiveModel::Validations

  validate  :game_running,
            :ship_exists,
            :matching_case_sensitive,
            :not_matching_own_ship,
            :ship_not_destroyed_yet,
            :mission_not_accomplished_yet

  private
  attr_reader :player, :perfect_typing, :word

  public

  def initialize(player:, word:, perfect_typing:)
    @player         = player
    @word           = word
    @perfect_typing = ['1', true].include?(perfect_typing)
  end

  def ship
    @ship ||= ships.where("LOWER(words.value) = LOWER(?)", word).first
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

  def game_running
    unless player.game.state == 'running'
      errors.add(:game, "not_running")
    end
  end

  def ship_not_destroyed_yet
    if ship&.state == 'destroyed'
      errors.add(:word, "already_destroyed")
    end
  end

  def mission_not_accomplished_yet
    if ship&.state == 'mission_accomplished'
      errors.add(:word, "bomb_already_dropped")
    end
  end

  def matching_case_sensitive
    matching_insensitive = ships.where.not(player_id: player.id).where("LOWER(words.value) = LOWER(:word) AND words.value != :word", word: word).exists?

    if matching_insensitive
      errors.add(:word, "wrong_case")
    end
  end

  def not_matching_own_ship
    matching = ships.where(player_id: player.id).where(words: { value: word }).exists?

    if matching
      errors.add(:word, "player_ship")
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
