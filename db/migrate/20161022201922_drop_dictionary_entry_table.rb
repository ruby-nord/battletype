class DropDictionaryEntryTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :dictionary_entries
  end
end
