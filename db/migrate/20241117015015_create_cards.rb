class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :term
      t.string :definition
      t.belongs_to :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
