class PayloadSerializer < Struct.new(:player, :ship)
  def to_json
    {
        player: player.nickname,
        launched_ship: {
            type: ship.ship_type,
            damage: ship.damage,
            velocity: ship.velocity
        }
    }
  end
end