class GameNeighbor < ActiveRecord::Base
  belongs_to :game
  belongs_to :neighbor, class_name: "Game", foreign_key: "neighbor_id"

  def self.delete_by_pair(pair)
    game = GameNeighbor.where("game_id = ? and neighbor_id = ?", pair["game_id"], pair["neighbor_id"]).first
    game.destroy
    game = GameNeighbor.where("game_id = ? and neighbor_id = ?", pair["neighbor_id"], pair["game_id"]).first
    game.destroy
  end
end
