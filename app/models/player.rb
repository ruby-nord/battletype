class Player < ApplicationRecord
  belongs_to :game

  has_many :ships, dependent: :destroy
end
