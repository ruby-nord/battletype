class DictionaryEntry < ApplicationRecord
  validates :word, presence: true
end