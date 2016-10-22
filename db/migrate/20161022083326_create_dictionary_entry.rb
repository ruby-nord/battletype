class CreateDictionaryEntry < ActiveRecord::Migration[5.0]
  def change
    create_table :dictionary_entries do |t|
      t.string :word,   null: false
      t.timestamps
    end
    add_index :dictionary_entries, :word
  end
end
