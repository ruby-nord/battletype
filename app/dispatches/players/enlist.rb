module Players
  class Enlist
    private
    attr_reader :game

    public
    attr_reader :player

    def initialize(game:, player:)
      @game   = game
      @player = player
    end

    def assign_game_to_player!
      @player = Player.create!(nickname: nickname, game: game, life: Player::LIFE)
      game.running! if game.full?

      return successful_payload
    end

    def available?
      game.state == 'awaiting_opponent' && !game.full?
    end

    private

    def nickname
      player&.nickname || Haikunator.haikunate(0)
    end

    def successful_payload
      {
        code:       'player_joined',
        player_id:  player.id,
        nickname:   player.nickname
      }
    end
  end
end
