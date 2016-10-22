module Users
  class Enlist
    MAX_PLAYERS = 2

   def initialize(game)
      @game = game
    end

    def call
      Player.create!(nickname: nickname)
    end

    def game_full?
      game.players.count >= MAX_PLAYERS
    end

    attr_reader :game

    private

    def nickname
      "Player #{game.players.count+1}"
    end
  end
end