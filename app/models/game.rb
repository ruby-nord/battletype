class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :ships,   through: :players
  has_many :words,   dependent: :destroy

  def to_param
    slug
  end
end
