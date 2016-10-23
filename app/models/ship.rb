# Available states:
# - engaged:              has been launched
# - down:                 has been destroyed by a defense
# - mission_accomplished: has bombed the opponent's mothership
class Ship < ApplicationRecord
  TYPES = [
    SMALL   = {
      ship_type: "small",
      damage:   1,
      velocity: 4
    },
    MEDIUM  = {
      ship_type: "medium",
      damage:   2,
      velocity: 6
    },
    LARGE   = {
      ship_type: "large",
      damage:   4,
      velocity: 12
    }
  ]

  belongs_to :player
  belongs_to :word
end
