class Word < ApplicationRecord
  belongs_to :game

  has_one :ship
end
