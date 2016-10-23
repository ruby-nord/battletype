module Bombs
  class Drop
    private
    attr_reader :attacked_player, :bomb, :game, :player, :word

    public

    def self.call(player:, word:)
      new(player: player, word: word).call
    end

    def initialize(player:, word:)
      @player          = player
      @word            = word
      @game            = player.game
      @attacked_player = game.players.where.not(id: player.id).first
    end

    def call
      @bomb = Bomb.new(player: player, word: word)
      return failed_payload unless bomb.valid?

      downgrade_attacked_player
      mission_accomplished!

      successful_payload
    end

    private

    def downgrade_attacked_player
      new_life = attacked_player.life - bomb.ship.damage
      attacked_player.update(
        life:         [0, new_life].max,
        strike_gauge: 0
      )

    end

    def failed_payload
      {
        code:         'failed_bombing',
        player_id:    player.id,
        word:         word,
        error_codes:  bomb.errors[:word]
      }
    end

    def mission_accomplished!
      bomb.ship.update(state: 'mission_accomplished')
    end

    def successful_payload
      {
        code:             'successful_bombing',
        player_id:        player.id,
        word:             word,
        bombed_mothership:  {
          life:             attacked_player.life,
          strike_gauge:     attacked_player.strike_gauge,
          unlocked_strike:  attacked_player.unlocked_strike
        }
      }
    end
  end
end
