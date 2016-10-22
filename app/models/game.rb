class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :words,   dependent: :destroy
end
