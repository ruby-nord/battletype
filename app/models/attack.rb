class Attack
  private
  attr_reader :game, :word

  public

  def initialize(game, word)
    @game = game
    @word = word
  end

  def valid?
    if @valid.nil?
      @valid = unique_case_insensitive_word?
    end

    @valid
  end

  private

  def unique_case_insensitive_word?
    Word.where(game: game).where('LOWER(value) = LOWER(?)', word).empty?
  end
end
