class Player < ApplicationRecord
  LIFE = 10

  belongs_to :game

  has_many :ships, dependent: :destroy
end
