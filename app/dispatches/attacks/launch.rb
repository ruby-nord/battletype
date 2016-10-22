module Attacks
  class Launch
    private
    attr_reader :game, :player, :saved_word, :word

    public

    def self.call(player:, word:)
      new(player: player, word: word).call
    end

    def initialize(player:, word:)
      @game   = player.game
      @player = player
      @word   = word
    end

    def call
      if attack.valid?
        save_word
        upgrade_fleet
      end

      return payload
    end

    def payload
      if attack.valid?
        PayloadSerializer.new(player, launched_ship).to_json
      else
        { player_id: player.id, word: word, error_codes: attack.errors[:word] }
      end
    end

    private

    def attack
      @attack ||= Attack.new(game, word, player)
    end

    def save_word
      @saved_word = Word.create!(value: word, game: game)
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
