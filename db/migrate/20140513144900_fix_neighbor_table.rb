class FixNeighborTable < ActiveRecord::Migration
  def up
    remove_column :game_neighbors, :game_id
  end

  def down
    add_column :game_neighbors, :game_id
  end
end
