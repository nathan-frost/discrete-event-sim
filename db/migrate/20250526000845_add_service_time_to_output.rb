class AddServiceTimeToOutput < ActiveRecord::Migration[8.0]
  def change
    add_column :outputs, :service_time, :float
  end
end
