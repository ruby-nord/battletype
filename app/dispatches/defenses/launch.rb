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
      return failed_payload unless defense.valid?

      shot_down_ship
      update_strike

      return successful_payload
    end

    private

    def shot_down_ship
      defense.ship.update(state: 'down')
    end

    def failed_payload
      { code: 'failed_defense', player_id: player.id, word: word, error_codes: error_codes }
    end

    def error_codes
      defense.errors.messages.values.flatten
    end

    def successful_payload
      { code: 'successful_defense', player_id: player.id, word: word, strike: { gauge: player.strike_gauge, unlocked: player.unlocked_strike }}
    end

    def update_strike
      player.update(
        strike_gauge:     defense.strike_gauge,
        unlocked_strike:  defense.unlocked_strike
      )
    end
  end
end
