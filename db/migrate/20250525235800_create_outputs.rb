class CreateOutputs < ActiveRecord::Migration[8.0]
  def change
    create_table :outputs do |t|
      t.integer :scenario_id
      t.integer :entity_id
      t.string :resource
      t.float :arrival_time
      t.float :start_service
      t.float :end_time
      t.string :wait_time

      t.timestamps
    end
  end
end
