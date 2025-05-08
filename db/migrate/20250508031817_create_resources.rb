class CreateResources < ActiveRecord::Migration[8.0]
  def change
    create_table :resources do |t|
      t.integer :scenario_id
      t.string :resource_name
      t.text :resource_description
      t.float :resource_capacity
      t.float :resource_time_mean
      t.float :resource_time_variance
      t.string :resource_time_distribution

      t.timestamps
    end
  end
end
