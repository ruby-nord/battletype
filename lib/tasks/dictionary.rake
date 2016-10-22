namespace :dico do
  desc "Import english word dictioanry"
  task update: :environment do
    DictionaryEntry.delete_all
    CSV.foreach('resources/dic/words.txt', :quote_char => "|") do |row|
      word = row[0]
      puts "create #{word}"
      DictionaryEntry.create(word: word)
    end
  end
end