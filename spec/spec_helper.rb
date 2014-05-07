require 'rspec/expectations'

$LOAD_PATH << "lib"
$LOAD_PATH << "models"

require 'environment'
require 'game'

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
  run_pn_with_input("4", "OD&D", "1", "Dungeons & Dragons", "Gary Gygax, Dave Arneson", "1974", "2", "1", "5", "2", "1", "2", "1")
  run_pn_with_input("4", "Basic D&D", "1", "B/X, BECMI, Red Box", "Eric J. Holmes, Tom Moldvay, Frank Mentzer, Aaron Allston", "1977", "2", "1", "5", "2", "1", "2", "1")
  run_pn_with_input("4", "AD&D 1e", "1", "Advanced Dungeons & Dragons 1st Edition", "Gary Gygax", "1978", "2", "2", "5", "2", "1", "2", "1")
  run_pn_with_input("4", "AD&D 2e", "1", "Advanced Dungeons & Dragons 2nd Edition", "David 'Zeb' Cook", "1989", "2", "2", "5", "1", "1", "2", "2")
end

RSpec.configure do |config|
  config.after(:each) do
    Environment.database_connection.execute("DELETE FROM games;")
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
