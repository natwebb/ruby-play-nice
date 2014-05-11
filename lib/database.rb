require "sqlite3"

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end

  def self.connection(environment)
    @connection ||= Database.new("db/play_nice_#{environment}.sqlite3")
  end

  def create_tables
    self.execute("CREATE TABLE games (id INTEGER PRIMARY KEY AUTOINCREMENT, name text, alt_names text, base_id int, neighbor_id int, author text, year int, AC text, race_as_class int, saves int, skills int, currency text, init text, xp_for_gp int)")
    self.execute("CREATE TABLE game_neighbors (game_id, neighbor_id)")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: #{statement} with: #{bind_vars}")
    super(statement, bind_vars)
  end
end
