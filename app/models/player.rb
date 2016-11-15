class Player < ApplicationRecord
  LIFE = 10

  belongs_to :game

  has_many :ships, dependent: :destroy
  
  def plays_in?(game)
    self.game == game
  end
end
