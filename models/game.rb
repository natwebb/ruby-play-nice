class Game < ActiveRecord::Base
  has_many :game_neighbors, dependent: :destroy
  has_many :neighbors, through: :game_neighbors

  validates :name, uniqueness: { message: "already exists." }

  def self.find_by_name(name)
    Game.find_by(name: name)
  end

  def self.find_by_id(id)
    Game.find_by(id: id)
  end

  def self.delete_by_name(name)
    game = Game.find_by(name: name)
    game.destroy if game
  end

  def self.get_base_games
    Game.where("id = base_id")
  end

  def self.get_related_games(base_id)
    Game.where(base_id: base_id)
  end

  def self.get_neighbor_games(game_id)
    game = find_by_id(game_id)
    neighbors = game.game_neighbors
    output = []
    neighbors.each do |neighbor|
      game = find_by_id(neighbor.neighbor_id)
      output << game if game
    end
    output
  end

  def self.get_by_rule(rule, setting)
    Game.where("#{rule} = ?", setting)
  end

  def update_game_info(base, alternate_names, authors, year)
    game = Game.find_by(name: name)
    game.update(base_id: base, alt_names: alternate_names, author: authors, year: year.to_i)
  end

  def update_game_rules(ac, race, saves, skills, currency, init, xpgp)
    game = Game.find_by(name: name)
    game.update(AC: ac, race_as_class: race, saves: saves, skills: skills, currency: currency, init: init, xp_for_gp: xpgp)
  end

end
