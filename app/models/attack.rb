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
      @valid = !Word.where(game: game, value: word).exists?
    end

    @valid
  end
end
