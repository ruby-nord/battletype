module Attacks
  class Launch
    private
    attr_reader :game, :player, :saved_word, :word

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
        upgrade_fleet
      end

      return attack
    end

    private

    def save_word
      @saved_word = Word.create!(value: word, game: game)
    end

    def upgrade_fleet
      base_characteristics = Attack.reward_for(word: word)
      ship_characteristics = base_characteristics.merge(
        state:  'engaged',
        player: player,
        word:   saved_word
      )

      Ship.create!(ship_characteristics)
    end
  end
end
