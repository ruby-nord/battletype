class Strike
  ALL = %w(hyperdrive jammer gauge_leak enlarger saboteur)

  def self.reward_for(gauge)
    case gauge
    when 0..9
      nil
    when 10..24
      :hyperdrive
    when 25..44
      :jammer
    when 45..69
      :gauge_leak
    when 70..99
      :enlarger
    when 100
      :saboteur
    end
  end
end
