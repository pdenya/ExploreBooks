class AddMoreBookIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :books, :quality, where: "quality = true"
  end
end
