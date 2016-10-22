module WordHelper
  def allow_words(words)
    [words].flatten.each { |w| DictionaryEntry.create(word: w) }
  end
end