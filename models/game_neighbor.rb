class GameNeighbor
  attr_reader :errors
  attr_reader :game_id
  attr_reader :neighbor_id

  def initialize(game_id, neighbor_id)
    @game_id = game_id
    @neighbor_id = neighbor_id
    @errors = []
  end

  def self.count
    statement = "Select count(*) from game_neighbors;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.find_by_game_id(game_id)
    statement = "Select * from game_neighbors where game_id = ?;"
    Environment.database_connection.execute(statement, game_id)
  end

  def save
    statement = "Insert into game_neighbors (game_id, neighbor_id) values (?, ?);"
    Environment.database_connection.execute(statement, [@game_id, @neighbor_id])
    true
  end

  def self.all
    statement = "select * from game_neighbors;"
    Environment.database_connection.execute(statement)
  end

  def self.delete_by_pair(pair)
    statement = "delete from game_neighbors where game_id = ? and neighbor_id = ?;"
    Environment.database_connection.execute(statement, [pair["game_id"], pair["neighbor_id"]])
    Environment.database_connection.execute(statement, [pair["neighbor_id"], pair["game_id"]])
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    results = Environment.database_connection.execute(statement, bind_vars)
    unless results.empty?
      links = []
      results.each do |result|
        game_id = result["game_id"]
        neighbor_id = result["neighbor_id"]
        links << GameNeighbor.new(game_id, neighbor_id)
      end
      links
    end
  end
end
