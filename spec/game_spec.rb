require_relative 'spec_helper'

describe Game do
  context "#new" do
    let(:game) {Game.new(name: "Labyrinth Lord")}

    it "should create a new Game with name stored" do
      game.name.should == "Labyrinth Lord"
    end
  end

  context ".count" do
    context "with nothing in the database" do
      it "should return 0" do
        Game.count.should == 0
      end
    end

    context "with multiple games in the database" do
      before do
        Game.new(name: "Labyrinth Lord").save
        Game.new(name: "OSRIC").save
        Game.new(name: "ACKS").save
        Game.new(name: "Mutant Future").save
      end

      it "should return the correct count" do
        Game.count.should == 4
      end
    end
  end

  context ".find_by_name" do
    context "with nothing in the database" do
      it "should return nil" do
        Game.find_by_name("Labyrinth Lord").should be_nil
      end
    end

    context "with a game by that name in the database" do
      before do
        Game.new(name: "Labyrinth Lord").save
        Game.new(name: "OSRIC").save
        Game.new(name: "ACKS").save
        Game.new(name: "Mutant Future").save
      end

      it "should return that game" do
        Game.find_by_name("Labyrinth Lord").name.should == "Labyrinth Lord"
      end
    end
  end

  context ".last" do
    context "with nothing in the database" do
      it "should return nil" do
        Game.last.should be_nil
      end
    end

    context "with multiple games in the database" do
      before do
        Game.new(name: "Labyrinth Lord").save
        Game.new(name: "OSRIC").save
        Game.new(name: "ACKS").save
        Game.new(name: "Mutant Future").save
      end

      it "should return the last one inserted" do
        Game.last.name.should == "Mutant Future"
      end
    end
  end

  context ".all" do
    context "with nothing in the database" do
      it "should return an empty array" do
        Game.all.length.should == 0
      end
    end

    context "with multiple games in the database" do
      before do
        Game.new(name: "Labyrinth Lord").save
        Game.new(name: "OSRIC").save
        Game.new(name: "ACKS").save
        Game.new(name: "Mutant Future").save
      end

      it "should return the number of games in the database" do
        Game.all.length.should == 4
      end
    end
  end

  context "#save" do
    let(:game_list){Game.connection.execute("Select name from games")}

    context "with a unique name" do
      let(:game){Game.new(name: "Labyrinth Lord")}

      it "should return true" do
        game.save.should be_true
      end

      it "should save only one row to the database" do
        game.save
        game_list.count.should == 1
      end

      it "should actually save it to the database" do
        game.save
        game_list[0]["name"].should == "Labyrinth Lord"
      end
    end

    context "with a duplicate name" do
      before do
        Game.new(name: "Labyrinth Lord").save
      end

      let(:game){Game.new(name: "Labyrinth Lord")}

      it "should return false" do
        game.save.should be_false
      end

      it "should not save a new game" do
        game.save
        game_list.count.should == 1
      end

      it "should save error messages" do
        game.save
        game.errors[:name].first.should == "already exists."
      end
    end
  end

  context ".delete_by_name" do
    before do
      Game.new(name: "Labyrinth Lord").save
      Game.new(name: "OSRIC").save
      Game.new(name: "ACKS").save
      Game.new(name: "Mutant Future").save
    end

    context "with a valid name" do
      before do
        Game.delete_by_name("OSRIC")
      end

      it "should delete the game from the database" do
        Game.count.should == 3
      end

      it "should not be able to find the game" do
        Game.find_by_name("OSRIC").should be_nil
      end
    end

    context "with an invalid name" do
      it "should not delete anything" do
        Game.delete_by_name("AD&D")
        Game.count.should == 4
      end
    end
  end

  context "#get_game_data" do
    let(:game){ Game.new(name: "OSRIC") }

    context "with no game data" do
      it "should return a mostly-empty hash" do
        game.save
        game.get_game_data["name"].should == "OSRIC"
        game.get_game_data["year"].should be_nil
      end
    end

    context "with game data" do
      it "should return a game's information" do
        game.save
        game.update_game_info("1", "Old-School Reference Index and Compilation", "Stewart Marshall", "2008")
        game.get_game_data["author"].should == "Stewart Marshall"
      end
    end
  end

  context "#update_game_info" do
    let(:game){ Game.new(name: "OSRIC") }

    it "should update a game's information" do
      game.save
      game.update_game_info("1", "Old-School Reference Index and Compilation", "Stuart Marshall", "1974")
      game.update_game_info("1", "Old-School Reference Index and Compilation", "Stewart Marshall", "2008")
      game.get_game_data["author"].should == "Stewart Marshall"
      game.get_game_data["year"].should == 2008
    end
  end

  context "#update_game_rules" do
    let(:game){ Game.new(name: "OSRIC") }

    it "should update a game's information" do
      game.save
      game.update_game_rules("ascending", 0, 3, 1, "gold", "individual", 0)
      game.update_game_rules("descending", 1, 5, 0, "gold", "group", 1)
      game.get_game_data["AC"].should == "descending"
      game.get_game_data["xp_for_gp"].should be_true
    end
  end

  context ".get_base_games" do
    before do
      populate_base
    end

    it "should return an array of base games" do
      Game.get_base_games.length.should == 4
    end

    it "should only include games with id = base_id" do
      games = Game.get_base_games

      games.each do |game|
        game["base_id"].should == game["id"]
      end
    end
  end

  context ".get_related_games" do
    before do
      populate_base
      run_pn_with_input("4", "OSRIC", "2", "3", "Old-School Reference and Index Compilation", "Stewart Marshall", "2008", "2", "2", "5", "2", "1", "2", "1", "q")
    end

    let(:base_id){ Game.find_by_name("AD&D 1e").id }

    it "should return an array of games matching a certain base id" do
      Game.get_related_games(base_id).length.should == 2
    end

    it "should only include games with base_id correct" do
      games = Game.get_related_games(base_id)

      games.each do |game|
        game["base_id"].should == base_id
      end
    end
  end

  context ".get_by_rule" do
    before do
      populate_base
    end

    it "should return an array of games with a certain rule" do
      Game.get_by_rule("skills", false).length.should == 3
    end

    it "should only include games with that rule setting" do
      games = Game.get_by_rule("skills", false)

      games.each do |game|
        game["skills"].should == false
      end
    end
  end

end
