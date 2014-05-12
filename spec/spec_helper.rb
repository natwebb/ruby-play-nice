require 'rspec/expectations'

$LOAD_PATH << "lib"
$LOAD_PATH << "models"

require 'environment'
require 'game'
require 'game_neighbor'

Environment.environment = "test"

def run_pn_with_input(*inputs)
  shell_output = ""
  IO.popen('ENVIRONMENT=test ./play_nice', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

def populate_base
  run_pn_with_input("4", "OD&D", "1", "Dungeons & Dragons", "Gary Gygax, Dave Arneson", "1974", "2", "1", "5", "2", "1", "2", "1", "q")
  run_pn_with_input("4", "Basic D&D", "1", "B/X, BECMI, Red Box", "Eric J. Holmes, Tom Moldvay, Frank Mentzer, Aaron Allston", "1977", "2", "1", "5", "2", "1", "2", "1", "q")
  run_pn_with_input("4", "AD&D 1e", "1", "Advanced Dungeons & Dragons 1st Edition", "Gary Gygax", "1978", "2", "2", "5", "2", "1", "2", "1", "q")
  run_pn_with_input("4", "AD&D 2e", "1", "Advanced Dungeons & Dragons 2nd Edition", "David 'Zeb' Cook", "1989", "2", "2", "5", "1", "1", "2", "2", "q")
end

def populate_more_games
  run_pn_with_input("4", "Labyrinth Lord Advanced Edition Companion", "2", "3", "LL AEC", "Daniel Proctor", "2010", "2", "2", "5", "2", "1", "2", "1", "q")
  run_pn_with_input("4", "Labyrinth Lord", "2", "2", "", "Daniel Proctor", "2008", "2", "2", "5", "2", "1", "2", "1", "q")
  run_pn_with_input("4", "OSRIC", "2", "3", "Old-School Reference and Index Compilation", "Stewart Marshall", "2008", "2", "2", "5", "2", "1", "2", "1", "q")
end

RSpec.configure do |config|
  config.after(:each) do
    Environment.database_connection.execute("DELETE FROM games;")
    Environment.database_connection.execute("DELETE FROM game_neighbors;")
  end
end

RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    input = actual.delete("\n")
    regexp_string = expected.join(".*").gsub("?","\\?").gsub("\n",".*")
    result = /#{regexp_string}/.match(input)
      result.should be
  end
end
