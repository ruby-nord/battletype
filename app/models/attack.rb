class Attack
  MIN_WORD_SIZE=2

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

  def initialize(game, word, player)
    @game = game
    @word = word
    @player = player
  end

  def valid?
    @valid ||= begin
      unique_case_insensitive_word? &&
      long_enough? &&
      english_word?
    end
  end
  
  private

  def unique_case_insensitive_word?
    Word.where(game: game).where('LOWER(value) = LOWER(?)', word).empty?
  end

  def long_enough?
    word.length >= MIN_WORD_SIZE
  end

  def english_word?
    DictionaryEntry.where(word: word.downcase).present?
  end
end
