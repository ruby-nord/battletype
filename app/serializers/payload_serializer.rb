class PayloadSerializer < Struct.new(:player, :ship)
  def to_json
    {
      code:       'successful_attack',
      player_id:  player.id,
      launched_ship: {
        word:     ship.word.value,
        type:     ship.ship_type,
        damage:   ship.damage,
        velocity: ship.velocity
      }
    }
  end
end
