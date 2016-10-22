class PayloadSerializer < Struct.new(:player, :ship)
  def to_json
    {
        player_id: player.id,
        launched_ship: {
            type: ship.ship_type,
            damage: ship.damage,
            velocity: ship.velocity
        }
    }
  end
end