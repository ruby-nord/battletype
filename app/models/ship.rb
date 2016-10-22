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
