class Game < ActiveRecord::Base
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

  def get_game_data
    Game.find_by(name: name)
  end

  def self.get_base_games
    Game.where("id = base_id")
  end

  def self.get_related_games(base_id)
    Game.where(base_id: base_id)
  end

  def self.get_neighbor_games(id)
    statement = "select * from games inner join game_neighbors on games.id = game_neighbors.neighbor_id where game_neighbors.game_id = ?;"
    Environment.database_connection.execute(statement, id)
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
