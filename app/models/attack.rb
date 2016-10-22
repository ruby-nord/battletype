class Attack
  def initialize(word)
    @word = word
  end

  def valid?
    @valid ||= true
  end
end
