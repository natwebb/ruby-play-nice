class GameNeighbor < ActiveRecord::Base
  def self.find_by_game_id(game_id)
    GameNeighbor.where(game_id: game_id)
  end

  def self.delete_by_pair(pair)
    game = GameNeighbor.where("game_id = ? and neighbor_id = ?", pair["game_id"], neighbor_id["neighbor_id"])
    game.destroy
    game = GameNeighbor.where("game_id = ? and neighbor_id = ?", pair["neighbor_id"], neighbor_id["game_id"])
    game.destroy
  end
end
