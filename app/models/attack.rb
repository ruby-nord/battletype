class Attack
  include ActiveModel::Validations
  MIN_WORD_SIZE = 2

  validate :game_running?, :unique_case_insensitive_word?, :english_word?, :long_enough?

  private
  attr_reader :game, :word, :player

  public

  def self.reward_for(word:)
    case word.length
    when 0..1
      nil
    when 2..3
      Ship::SMALL
    when 4..6
      Ship::MEDIUM
    else
      Ship::LARGE
    end
  end

  def initialize(game:, word:, player:)
    @game   = game
    @word   = word
    @player = player
  end

  private

  def game_running?
    unless game.state == 'running'
      errors.add(:game, "not_running")
    end
  end

  def unique_case_insensitive_word?
    unless Word.where(game: game).where('LOWER(value) = LOWER(?)', word).empty?
      errors.add(:word, "unique_case_insensitive_word")
    end
  end

  def long_enough?
    unless word.length >= MIN_WORD_SIZE
      errors.add(:word, "long_enough")
    end
  end

  def english_word?
    unless DictionaryEntry.contains?(word: word.downcase)
      errors.add(:word, "english_word")
    end
  end
end
