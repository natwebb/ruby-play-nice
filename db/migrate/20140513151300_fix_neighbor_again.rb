class FixNeighborAgain < ActiveRecord::Migration
  def up
    add_column :game_neighbors, :game_id, :integer
  end

  def down
    remove_column :game_neighbors, :game_id
  end
end
