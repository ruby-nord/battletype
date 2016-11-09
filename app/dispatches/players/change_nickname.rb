module Players
  class ChangeNickname
    private
    attr_reader :nickname, :player

    public

    def self.call(player:, nickname:)
      new(player: player, nickname: nickname).call
    end

    def initialize(player:, nickname:)
      @nickname = nickname
      @player   = player
    end

    def call
      update_nickname

      return successful_payload
    end

    private

    def update_nickname
      player.update(nickname: nickname)
    end

    def successful_payload
      { code: "player_nickname_changed", player_id: @player.id, nickname:  @player.nickname }
    end
  end
end
