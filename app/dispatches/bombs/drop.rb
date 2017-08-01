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
      return failed_payloads unless bomb.valid?

      mission_accomplished!
      downgrade_attacked_player

      if game_won?
        finish_game
      end

      successful_payloads
    end

    private

    def downgrade_attacked_player
      new_life = attacked_player.life - bomb.ship.damage

      attacked_player.update(
        life:         [0, new_life].max,
        strike_gauge: 0
      )
    end

    def failed_payloads
      [{
        code:         'failed_bombing',
        player_id:    player.id,
        word:         word,
        error_codes:  error_codes
      }]
    end

    def error_codes
      bomb.errors.messages.values.flatten
    end

    def game_won?
      attacked_player.life == 0
    end

    def mission_accomplished!
      bomb.ship.update(state: 'mission_accomplished')
    end

    def successful_payloads
      payloads = [{
        code:             'successful_bombing',
        player_id:        player.id,
        word:             word,
        bombed_mothership:  {
          life:             attacked_player.life,
          strike_gauge:     attacked_player.strike_gauge,
          unlocked_strike:  attacked_player.unlocked_strike
        }
      }]

      if player.won
        payloads << {
          code:      'game_won',
          player_id: player.id
        }
      end

      payloads
    end

    def finish_game
      player.update(won: true)
      game.finished!
    end
  end
end
