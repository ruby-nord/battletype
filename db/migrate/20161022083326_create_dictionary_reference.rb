class CreateDictionaryReference < ActiveRecord::Migration[5.0]
  def change
    create_table :dictionary_references do |t|
      t.string :word,   null: false
      t.timestamps
    end
    add_index :dictionary_references, :words
  end
end
