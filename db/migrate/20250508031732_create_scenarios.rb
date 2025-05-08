class CreateScenarios < ActiveRecord::Migration[8.0]
  def change
    create_table :scenarios do |t|
      t.integer :user_id
      t.string :scenario_name
      t.text :scenario_description
      t.float :scenario_length

      t.timestamps
    end
  end
end
