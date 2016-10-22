class Ship < ApplicationRecord
  TYPES = [
    SMALL   = {
      damage:   1,
      velocity: 4
    },
    MEDIUM  = {
      damage:   2,
      velocity: 6
    },
    LARGE   = {
      damage:   4,
      velocity: 12
    }
  ]

  belongs_to :player
  belongs_to :word
end
