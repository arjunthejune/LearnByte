class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
