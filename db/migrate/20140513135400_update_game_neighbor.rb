class UpdateGameNeighbor < ActiveRecord::Migration
  def up
    remove_column :game_neighbors, :game_id
    rename_column :game_neighbors, :neighbor_id, :neighbor
  end

  def down
    add_column :game_neighbors, :game_id, :integer
    rename_column :game_neighbors, :neighbor, :neighbor_id
  end
end
