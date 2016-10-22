class PayloadSerializer < Struct.new(:player, :word, :ship)
  def to_h
    {
      code:       'successful_attack',
      player_id:  player.id,
      word:       word,
      launched_ship: {
        type:     ship.ship_type,
        damage:   ship.damage,
        velocity: ship.velocity
      }
    }
  end
end
