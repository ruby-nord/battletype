module Players
  class Enlist
    MAX_PLAYERS = 2

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
      @game.update(state: 'running')

      return successful_payload
    end

    def game_full?
      game.players.count >= MAX_PLAYERS
    end

    private

    def nickname
      player&.nickname || Haikunator.haikunate(0)
    end

    def successful_payload
      {
        code:       'player_joined',
        player_id:  player.id
      }
    end
  end
end
