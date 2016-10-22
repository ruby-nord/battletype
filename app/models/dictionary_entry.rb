class DictionaryEntry
  include ActiveModel::Model
  attr_accessor :word

  validates :word, presence: true

  class << self
    def contains?(word:)
      $redis.sismember(key, word.downcase)
    end

    def create(word:)
      $redis.sadd(key, word.downcase)
    end

    def delete_all
      $redis.del(key)
    end

    private
    def key
      "battletype:dictionary_entries"
    end
  end
end