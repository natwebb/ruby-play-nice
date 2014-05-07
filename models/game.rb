class Game
  attr_reader :errors
  attr_reader :name
  attr_reader :id

  def initialize(name, id = false)
    @name = name
    @id = id ? id : 0
    @errors = []
  end

  def self.count
    statement = "Select count(*) from games;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.find_by_name(name)
    statement = "Select * from games where name = ?;"
    execute_and_instantiate(statement, name)
  end

  def self.last
    statement = "Select * from games order by id DESC limit(1);"
    execute_and_instantiate(statement)
  end

  def save
    if Game.find_by_name(self.name)
      @errors << "#{self.name} already exists."
      false
    else
      statement = "Insert into games (name) values (?);"
      Environment.database_connection.execute(statement, self.name)
      statement = "Select id from games where name = ?;"
      @id = Environment.database_connection.execute(statement, self.name)[0][0]
      true
    end
  end

  def self.delete_by_name(name)
    statement = "delete from games where name = ?;"
    Environment.database_connection.execute(statement, name)
  end

  def get_game_data
    statement = "Select * from games where name = ?;"
    Environment.database_connection.execute(statement, self.name)[0]
  end

  def self.get_base_games
    statement = "Select * from games where id = base_id;"
    Environment.database_connection.execute(statement)
  end

  def self.get_related_games(base_id)
    statement = "select * from games where base_id = ?;"
    Environment.database_connection.execute(statement, base_id)
  end

  def update_game_info(base, alternate_names, authors, year)
    statement = "Update games set base_id = ?, alt_names = ?, author = ?, year = ? where name = ?;"
    Environment.database_connection.execute(statement, [base, alternate_names, authors, year.to_i, self.name])
  end

  def update_game_rules(ac, race, saves, skills, currency, init, xpgp)
    statement = "Update games set AC = ?, race_as_class = ?, saves = ?, skills = ?, currency = ?, init = ?, xp_for_gp = ? where name = ?;"
    Environment.database_connection.execute(statement, [ac, race, saves, skills, currency, init, xpgp, self.name])
  end

  def self.all
    statement = "select * from games;"
    Environment.database_connection.execute(statement)
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    result = Environment.database_connection.execute(statement, bind_vars)
    unless result.empty?
      name = result[0]["name"]
      id = result[0]["id"]
      Game.new(name, id)
    end
  end
end
