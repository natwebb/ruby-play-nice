class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :alt_names
      t.integer :base_id
      t.string :author
      t.integer :year
      t.string :AC
      t.boolean :race_as_class
      t.integer :saves
      t.boolean :skills
      t.string :currency
      t.string :init
      t.boolean :xp_for_gp
      t.timestamps
    end
  end
end
