require_relative "spec_helper"

describe "Adding a game" do
  before do
    game = Game.new("Labyrinth Lord")
    game.save
  end

  context "with a unique name" do
    let!(:output){run_pn_with_input("4", "OSRIC")}
    it "should print a confirmation message" do
      output.should include("OSRIC has been added.")
      Game.count.should == 2
    end

    it "should insert a new game" do
      Game.count.should == 2
    end

    it "should use the name we entered" do
      Game.last.name.should == "OSRIC"
    end
  end

  context "with a duplicate name" do
    let(:output){ run_pn_with_input("4", "Labyrinth Lord") }
    it "should print an error message" do
      output.should include("Labyrinth Lord already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Enter the name of the game to add."
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Game.count.should == 1
    end
    context "trying again" do
      let!(:output){ run_pn_with_input("4", "Labyrinth Lord", "ACKS") }
      it "should save a unique item" do
        Game.last.name.should == "ACKS"
      end
      it "should print a success message at the end" do
        output.should include("ACKS has been added")
      end
    end
  end
end

describe "Updating a game" do
  before do
    game = Game.new("OSRIC")
    game.save
    populate_base
  end

  context "when the game exists" do
    let!(:output_a){ run_pn_with_input("5", "OSRIC", "1", "2", "3", "Old-School Index Reference and Compilation", "Stewart Marshall", "2008") }
    it "should change the game info" do
      Game.find_by_name("OSRIC").get_game_data["alt_names"].should include("Old-School Index Reference and Compilation")
    end

    let!(:output_b){ run_pn_with_input("5", "OSRIC", "2", "2", "2", "5", "2", "1", "2", "1") }
    it "should change the game rules" do
      Game.find_by_name("OSRIC").get_game_data["AC"].should include("descending")
    end

    it "should still have only one game in the db" do
      Game.count.should == 5
    end
  end

  context "when the game doesn't exist" do
    let(:output){ run_pn_with_input("5", "ACKS") }
    it "should give an error message" do
      output.should include("ACKS cannot be found in the database")
    end

    it "should ask for the name again" do
      output.should include_in_order("Enter the name of the game to edit.", "ACKS cannot be found in the database", "Enter the name of the game to edit.")
    end
  end
end
