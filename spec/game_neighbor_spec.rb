require_relative 'spec_helper'

describe GameNeighbor do
  context "#new" do
    before do
      populate_base
      populate_more_games
    end

    let(:neighbor) do
      id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
      id_b = Game.find_by_name("Labyrinth Lord Advanced Edition Companion").get_game_data["id"]
      GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
    end

    it "should create a new GameNeighbor with ids stored" do
      neighbor.game_id.should == Game.find_by_name("Labyrinth Lord").get_game_data["id"]
      neighbor.neighbor_id.should == Game.find_by_name("Labyrinth Lord Advanced Edition Companion").get_game_data["id"]
    end
  end

  context ".count" do
    context "with nothing in the database" do
      it "should return 0" do
        GameNeighbor.count.should == 0
      end
    end

    context "with a relationship in the database" do
      before do
        populate_base
        populate_more_games
      end

      let(:neighbor) do
        id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        id_b = Game.find_by_name("Labyrinth Lord Advanced Edition Companion").get_game_data["id"]
        GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
      end

      it "should return the correct count" do
        neighbor.save
        GameNeighbor.count.should == 1
      end
    end
  end

  context ".find_by_game_id" do
    context "with nothing in the database" do
      it "should return an empty array" do
        GameNeighbor.find_by_game_id(0).should == []
      end
    end

    context "with games by that id in the database" do
      before do
        populate_base
        populate_more_games
      end

      let(:neighbor) do
        id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        id_b = Game.find_by_name("Labyrinth Lord Advanced Edition Companion").get_game_data["id"]
        GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
      end

      let(:neighbor_b) do
        id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        id_b = Game.find_by_name("OSRIC").get_game_data["id"]
        GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
      end

      it "should return an array with all neighbors of that game" do
        neighbor.save
        neighbor_b.save
        game_id = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        GameNeighbor.find_by_game_id(game_id)[0]["game_id"].should == game_id
        GameNeighbor.find_by_game_id(game_id)[1]["game_id"].should == game_id
        GameNeighbor.find_by_game_id(game_id).length.should == 2
      end
    end
  end

  context ".all" do
    context "with nothing in the database" do
      it "should return an empty array" do
        GameNeighbor.all.length.should == 0
      end
    end

    context "with multiple links in the database" do
      before do
        populate_base
        populate_more_games
      end

      let(:neighbor) do
        id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        id_b = Game.find_by_name("Labyrinth Lord Advanced Edition Companion").get_game_data["id"]
        GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
      end

      let(:neighbor_b) do
        id_a = Game.find_by_name("Labyrinth Lord").get_game_data["id"]
        id_b = Game.find_by_name("OSRIC").get_game_data["id"]
        GameNeighbor.new({game_id: id_a, neighbor_id: id_b})
      end

      it "should return the number of links in the database" do
        neighbor.save
        neighbor_b.save
        GameNeighbor.all.length.should == 2
      end
    end
  end

end
