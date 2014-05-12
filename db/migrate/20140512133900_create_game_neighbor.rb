class CreateGameNeighbor < ActiveRecord::Migration
  def change
    create_table :game_neighbors do |t|
      t.integer :game_id
      t.integer :neighbor_id
      t.timestamps
    end
  end
end
