require_relative 'spec_helper'

describe "Menu integration:" do
  let(:menu_text) do
<<EOS
Welcome to Play Nice! Please choose one of the following options.
1. Choose your game
2. Browse by base game
3. Search games by rules
4. New game
5. Edit game
6. Link games
7. Unlink games
8. Delete game
t. Top menu
q. Quit
EOS
  end

  context "Startup" do
    let(:shell_output){ run_pn_with_input("q") }
    it "should display the menu" do
      shell_output.should include(menu_text)
    end
  end

  context "the user chooses 1" do
    let(:shell_output){ run_pn_with_input("1", "q") }
    it "should print the game list prompt" do
      shell_output.should include("Please choose your game from the list.")
    end
  end

  context "the user chooses 2" do
    let(:shell_output){ run_pn_with_input("2", "q") }
    it "should print the game list prompt" do
      shell_output.should include("Please choose a base game from the list.")
    end
  end

  context "the user chooses 3" do
    let(:shell_output){ run_pn_with_input("3", "q") }
    it "should print the game list prompt" do
      shell_output.should include("Please choose a key rule from the list.")
    end
  end

  context "the user chooses anything outside the allowed inputs" do
    let(:shell_output){ run_pn_with_input("x", "q") }
    it "should reprint the top menu" do
      shell_output.should include_in_order(menu_text, "x", menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'x' is not a valid option. Please try again.")
    end
  end
end
