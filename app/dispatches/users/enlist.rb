module Users
  class Enlist
    def self.call(game)
      new(game).call
    end

    def initialize(game)
      @game = game
    end

    def call
      player = Player.create!(nickname: nickname)
      session[:player_id] = player.id
    end

    attr_reader :game

    private

    def nickname
      "Player #{game.players.count+1}"
    end
  end
end