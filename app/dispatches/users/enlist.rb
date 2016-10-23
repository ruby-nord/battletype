module Users
  class Enlist
    MAX_PLAYERS = 2
    attr_reader :player

    def initialize(game:, player:)
      @game = game
      @player = player
    end

    def assign_game_to_player!
      @player = Player.create!(nickname: nickname, game: game)
    end

    def game_full?
      game.players.count >= MAX_PLAYERS
    end

    private
    attr_reader :game

    def nickname
      player&.nickname || Haikunator.haikunate(0)
    end
  end
end