module Defenses
  class Launch
    private
    attr_reader :defense, :player, :word, :perfect_typing

    public

    def self.call(player:, word:, perfect_typing:)
      new(player: player, word: word, perfect_typing: perfect_typing).call
    end

    def initialize(player:, word:, perfect_typing:)
      @player         = player
      @word           = word
      @perfect_typing = perfect_typing
    end

    def call
      @defense = Defense.new(player: player, word: word, perfect_typing: perfect_typing)

      if defense.valid?
        destroy_ship
        update_strike_gauge
      end

      return defense
    end

    private

    def destroy_ship
      defense.ship.update(state: 'destroyed')
    end

    def update_strike_gauge
      player.update(strike_gauge: defense.strike_gauge)
    end
  end
end
