module Attacks
  class Launch
    private
    attr_reader :game, :player, :word

    public

    def self.call(player, word)
      new(player, word).call
    end

    def initialize(player, word)
      @game   = player.game
      @player = player
      @word   = word
    end

    def call
      attack = Attack.new(game, word)

      if attack.valid?
        save_word
      end

      return attack
    end

    private

    def save_word
      Word.create!(value: word, game: game)
    end
  end
end
