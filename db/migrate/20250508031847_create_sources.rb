class CreateSources < ActiveRecord::Migration[8.0]
  def change
    create_table :sources do |t|
      t.integer :scenario_id
      t.float :arrival_interval_mean
      t.float :arrival_interval_variance
      t.string :arrival_interval_distribution

      t.timestamps
    end
  end
end
