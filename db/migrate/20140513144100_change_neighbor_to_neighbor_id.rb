class ChangeNeighborToNeighborId < ActiveRecord::Migration
  def up
    rename_column :game_neighbors, :neighbor, :neighbor_id
  end

  def down
    rename_column :game_neighbors, :neighbor_id, :neighbor
  end
end
