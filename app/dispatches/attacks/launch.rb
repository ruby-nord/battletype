module Attacks
  class Launch
    private
    attr_reader :attack, :game, :player, :saved_word, :word

    public

    def self.call(player:, word:)
      new(player: player, word: word).call
    end

    def initialize(player:, word:)
      @game   = player.game
      @player = player
      @word   = word
      @attack = Attack.new(game: game, word: word, player: player)
    end

    def call
      return failed_payload unless attack.valid?

      save_word
      upgrade_fleet

      return successful_payload
    end

    private

    def failed_payload
      { code: 'failed_attack', player_id: player.id, word: word, error_codes: error_codes }
    end

    def error_codes
      attack.errors.messages.values.flatten
    end

    def save_word
      @saved_word = Word.create!(value: word, game: game)
    end

    def successful_payload
      PayloadSerializer.new(player, word, launched_ship).to_h
    end

    def upgrade_fleet
      player.ships << launched_ship
    end

    def launched_ship
      base_characteristics = Attack.reward_for(word: word)
      ship_characteristics = base_characteristics.merge(state: 'engaged', word: saved_word)

      Ship.new(ship_characteristics)
    end
  end
end
