module Attacks
  class Launch
    private
    attr_reader :player, :word

    public

    def self.call(player, word)
      new(player, word).call
    end

    def initialize(player, word)
      @player = player
      @word   = word
    end

    def call
      save_word

      Attack.new(word)
    end

    private

    def save_word
      Word.create(value: word, game: player.game)
    end
  end
end
