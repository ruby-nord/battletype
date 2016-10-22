module Defenses
  class Launch
    private
    attr_reader :player, :word

    public

    def self.call(player, word)
      new(player, word).call
    end

    def initialize(player, word)
      @player = player
      @word   = word
    end

    def call
      defense = Defense.new(player, word)

      if defense.valid?
        defense.ship.update(state: 'destroyed')
      end

      return defense
    end
  end
end
