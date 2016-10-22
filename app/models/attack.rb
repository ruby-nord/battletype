class Attack
  MIN_WORD_SIZE=2

  private
  attr_reader :game, :word

  public

  def initialize(game, word)
    @game = game
    @word = word
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
