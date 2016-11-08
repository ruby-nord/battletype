# Available states:
# - awaiting_opponent: the game is waiting for an other player to join in
# - running:  the game is started
# - finished: game over. A player has destroyed his ennemy mothership
class Game < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :ships,   through: :players
  has_many :words,   dependent: :destroy

  has_one :loser,  -> { where(won: false ) }, class_name: 'Player'
  has_one :winner, -> { where(won: true ) },  class_name: 'Player'

  def to_param
    slug
  end
end
