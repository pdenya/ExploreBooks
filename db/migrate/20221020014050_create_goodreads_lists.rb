class CreateGoodreadsLists < ActiveRecord::Migration[6.1]
  def change
    create_table :goodreads_lists do |t|
      t.integer :goodreads_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
