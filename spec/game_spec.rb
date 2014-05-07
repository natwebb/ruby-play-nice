require_relative 'spec_helper'

describe Game do
  context "#new" do
    let(:game) {Game.new("Labyrinth Lord")}

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
        Game.new("Labyrinth Lord").save
        Game.new("OSRIC").save
        Game.new("ACKS").save
        Game.new("Mutant Future").save
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
        Game.new("Labyrinth Lord").save
        Game.new("OSRIC").save
        Game.new("ACKS").save
        Game.new("Mutant Future").save
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
        Game.new("Labyrinth Lord").save
        Game.new("OSRIC").save
        Game.new("ACKS").save
        Game.new("Mutant Future").save
      end

      it "should return the last one inserted" do
        Game.last.name.should == "Mutant Future"
      end
    end
  end

  context "#save" do
    let(:game_list){Environment.database_connection.execute("Select name from games")}

    context "with a unique name" do
      let(:game){Game.new("Labyrinth Lord")}

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
        Game.new("Labyrinth Lord").save
      end

      let(:game){Game.new("Labyrinth Lord")}

      it "should return false" do
        game.save.should be_false
      end

      it "should not save a new game" do
        game.save
        game_list.count.should == 1
      end

      it "should save error messages" do
        game.save
        game.errors.first.should == "Labyrinth Lord already exists."
      end
    end
  end
end
