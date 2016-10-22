class Ship < ApplicationRecord
  belongs_to :player
  belongs_to :word
end
